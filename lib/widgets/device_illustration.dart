import 'package:flutter/material.dart';

import '../models/device_model.dart';

/// Large child-friendly cartoon-style illustration for a device.
class DeviceIllustration extends StatelessWidget {
  const DeviceIllustration({
    super.key,
    required this.device,
    this.size = 160,
  });

  final DeviceModel device;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            device.color.withValues(alpha: 0.3),
            device.color.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: device.color, width: 4),
        boxShadow: [
          BoxShadow(
            color: device.color.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(device.emoji, style: TextStyle(fontSize: size * 0.45)),
    );
  }
}

class SuccessIllustration extends StatelessWidget {
  const SuccessIllustration({super.key, this.size = 180});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF176), Color(0xFFFFD54F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFFFFB300), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Text('🎉', style: TextStyle(fontSize: 80)),
    );
  }
}

class FailureIllustration extends StatelessWidget {
  const FailureIllustration({super.key, this.size = 160});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFFECB3),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFB74D), width: 4),
      ),
      alignment: Alignment.center,
      child: const Text('🤔', style: TextStyle(fontSize: 72)),
    );
  }
}

class TreasureChestIllustration extends StatelessWidget {
  const TreasureChestIllustration({
    super.key,
    required this.isOpen,
    this.size = 180,
  });

  final bool isOpen;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: Container(
        key: ValueKey(isOpen),
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isOpen
                ? [const Color(0xFFFFD54F), const Color(0xFFFF8F00)]
                : [const Color(0xFF8D6E63), const Color(0xFF5D4037)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isOpen ? const Color(0xFFFFB300) : const Color(0xFF4E342E),
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: isOpen ? 0.5 : 0.2),
              blurRadius: isOpen ? 30 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          isOpen ? '🎁' : '📦',
          style: TextStyle(fontSize: size * 0.45),
        ),
      ),
    );
  }
}

class StickerIllustration extends StatelessWidget {
  const StickerIllustration({
    super.key,
    required this.stickerIndex,
    this.size = 140,
  });

  final int stickerIndex;
  final double size;

  static const List<String> _stickers = ['🏆', '🌟', '🦸', '🎖️', '🚀'];

  @override
  Widget build(BuildContext context) {
    final emoji = _stickers[stickerIndex % _stickers.length];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFF7043), width: 5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7043).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}
