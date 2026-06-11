import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/progress_provider.dart';
import '../widgets/device_illustration.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  static const List<String> _quotes = [
    'Excellent Work!',
    'Keep It Up!',
    'Super Explorer!',
    'Amazing Job!',
    'You Are A Learning Champion!',
  ];

  late final String _quote;
  late final int _stickerIndex;
  bool _chestOpen = false;
  bool _stickerRevealed = false;
  bool _stickerCollected = false;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _quote = _quotes[random.nextInt(_quotes.length)];
    _stickerIndex = random.nextInt(5);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _chestOpen = true);
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _stickerRevealed = true);
    });
  }

  void _collectSticker() {
    setState(() => _stickerCollected = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sticker collected! Great job, explorer!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  void _playAgain() {
    context.read<ProgressProvider>().reset();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFE1F5FE), Color(0xFFF3E5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Treasure Reward!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFF6F00),
                      ),
                ),
                const SizedBox(height: 8),
                const Text('⭐ ⭐ ⭐ ⭐ ⭐', style: TextStyle(fontSize: 28)),
                const Spacer(),
                AnimatedOpacity(
                  opacity: _stickerRevealed ? 0.3 : 1,
                  duration: const Duration(milliseconds: 500),
                  child: TreasureChestIllustration(isOpen: _chestOpen, size: 160),
                ),
                if (_stickerRevealed) ...[
                  const SizedBox(height: 20),
                  AnimatedScale(
                    scale: _stickerRevealed ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    child: StickerIllustration(stickerIndex: _stickerIndex),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _quote,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6A1B9A),
                        ),
                  ),
                ],
                const Spacer(),
                if (_stickerRevealed && !_stickerCollected)
                  _RewardButton(
                    label: 'Collect Sticker',
                    color: const Color(0xFF7E57C2),
                    onPressed: _collectSticker,
                  ),
                if (_stickerCollected)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Sticker added to your collection!',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                _RewardButton(
                  label: 'Play Again',
                  color: const Color(0xFF26A69A),
                  onPressed: _playAgain,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardButton extends StatelessWidget {
  const _RewardButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(28),
      elevation: 6,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
