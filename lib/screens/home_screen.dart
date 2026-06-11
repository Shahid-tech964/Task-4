import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../models/device_model.dart';
import '../services/progress_provider.dart';
import '../widgets/progress_card.dart';
import 'camera_screen.dart';
import 'reward_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.1);
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speakMission() async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
      return;
    }
    setState(() => _isSpeaking = true);
    await _tts.speak('Can you find these 5 objects around you?');
  }

  Future<void> _openCamera() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const CameraScreen()),
    );
  }

  void _openReward() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const RewardScreen()),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFF9C4), Color(0xFFFCE4EC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Little Explorer',
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF1565C0),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Find These 5 Objects',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF546E7A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Material(
                              color: const Color(0xFFFF7043),
                              borderRadius: BorderRadius.circular(20),
                              elevation: 4,
                              child: InkWell(
                                onTap: _speakMission,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    _isSpeaking ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('⭐', style: TextStyle(fontSize: 28)),
                              const SizedBox(width: 10),
                              Text(
                                '${progress.foundCount}/5 Found',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...DeviceModel.allDevices.map(
                          (device) => ProgressCard(
                            device: device,
                            isFound: progress.isFound(device.type),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        _LargeActionButton(
                          onPressed: _openCamera,
                          backgroundColor: const Color(0xFF42A5F5),
                          icon: Icons.camera_alt_rounded,
                          label: 'Take Picture',
                        ),
                        const SizedBox(height: 14),
                        _LargeActionButton(
                          onPressed: progress.allFound ? _openReward : null,
                          backgroundColor: progress.allFound
                              ? const Color(0xFFFFB300)
                              : Colors.grey.shade400,
                          icon: progress.allFound ? Icons.card_giftcard_rounded : Icons.lock_rounded,
                          label: progress.allFound
                              ? '🎁 Open Treasure Reward'
                              : '🔒 Unlock Treasure Reward',
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LargeActionButton extends StatelessWidget {
  const _LargeActionButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final Color backgroundColor;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(28),
      elevation: onPressed != null ? 6 : 0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
