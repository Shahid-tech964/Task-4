import 'package:flutter/material.dart';

import '../models/device_model.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.device,
    required this.isFound,
  });

  final DeviceModel device;
  final bool isFound;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isFound ? device.color.withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFound ? device.color : Colors.grey.shade300,
          width: isFound ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isFound
                ? device.color.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: isFound ? 8 : 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: isFound
                ? _DeviceAvatar(key: ValueKey('found-${device.type}'), device: device)
                : _PlaceholderAvatar(
                    key: ValueKey('placeholder-${device.type}'),
                    device: device,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              device.displayName,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isFound ? device.color : Colors.grey.shade600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isFound) ...[
            const Text('⭐', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 6),
            Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 28),
          ] else
            Icon(Icons.help_outline_rounded, color: Colors.grey.shade400, size: 24),
        ],
      ),
    );
  }
}

class _DeviceAvatar extends StatelessWidget {
  const _DeviceAvatar({super.key, required this.device});

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: device.color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: device.color, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(device.emoji, style: const TextStyle(fontSize: 28)),
    );
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  const _PlaceholderAvatar({super.key, required this.device});

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 26),
    );
  }
}
