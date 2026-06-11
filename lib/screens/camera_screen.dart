import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../services/mlkit_service.dart';
import '../services/progress_provider.dart';
import 'failure_screen.dart';
import 'success_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitializing = true;
  bool _isProcessing = false;
  String? _errorMessage;
  final MlKitService _mlKitService = MlKitService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() {
        _isInitializing = false;
        _errorMessage = 'Camera permission is required to take pictures.';
      });
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
          _errorMessage = 'No camera found on this device.';
        });
        return;
      }

      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller!.initialize();

      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _errorMessage = 'Could not start camera. Please try again.';
        });
      }
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final photo = await _controller!.takePicture();
      final labelResults = await _mlKitService.analyzeImage(photo.path);
      final matchedDevice = _mlKitService.matchDevice(labelResults);

      if (!mounted) return;

      if (matchedDevice == null) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FailureScreen()),
        );
        return;
      }

      final progress = context.read<ProgressProvider>();
      if (progress.isFound(matchedDevice.type)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('You already found this object.'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: const Color(0xFF546E7A),
            ),
          );
          Navigator.of(context).pop();
        }
        return;
      }

      progress.markFound(matchedDevice.type);

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SuccessScreen(device: matchedDevice),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _mlKitService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: const Text('Find a Device'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isInitializing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text('Starting camera...', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined, size: 64, color: Colors.white54),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final controller = _controller!;
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(controller),
        if (_isProcessing)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Looking for devices...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: GestureDetector(
              onTap: _isProcessing ? null : _captureAndAnalyze,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                  color: _isProcessing ? Colors.grey : Colors.white24,
                ),
                child: const Icon(Icons.camera, color: Colors.white, size: 36),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
