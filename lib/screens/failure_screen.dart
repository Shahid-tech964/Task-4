import 'package:flutter/material.dart';

import '../widgets/device_illustration.dart';
import 'camera_screen.dart';

class FailureScreen extends StatelessWidget {
  const FailureScreen({super.key});

  void _tryAgain(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CameraScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFEBEE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const FailureIllustration(),
                const SizedBox(height: 28),
                Text(
                  "Oops! That's not one of the electrical devices.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF546E7A),
                      ),
                ),
                const Spacer(),
                Material(
                  color: const Color(0xFFFF7043),
                  borderRadius: BorderRadius.circular(28),
                  elevation: 6,
                  child: InkWell(
                    onTap: () => _tryAgain(context),
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      alignment: Alignment.center,
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
