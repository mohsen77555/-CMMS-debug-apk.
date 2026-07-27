import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/kid_audio_service.dart';
import '../services/kid_progress_service.dart';
import '../theme/app_theme.dart';

class BubbleGameScreen extends StatefulWidget {
  const BubbleGameScreen({super.key});

  @override
  State<BubbleGameScreen> createState() => _BubbleGameScreenState();
}

class _BubbleGameScreenState extends State<BubbleGameScreen> {
  final _random = Random();
  Timer? _timer;
  int _score = 0;
  int _combo = 0;
  int _timeLeft = 30;
  int _bubbleKey = 0;
  Alignment _alignment = Alignment.center;
  double _size = 120;
  Color _color = KidPalette.sky;
  bool _playing = false;

  static const _colors = [KidPalette.sky, KidPalette.lavender, KidPalette.pink, KidPalette.mint, KidPalette.coral, KidPalette.sunshine];

  @override
  void initState() {
    super.initState();
    _moveBubbleInternal();
  }

  void _start() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _combo = 0;
      _timeLeft = 30;
      _playing = true;
      _moveBubbleInternal();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return;
      if (_timeLeft <= 1) {
        timer.cancel();
        setState(() {
          _timeLeft = 0;
          _playing = false;
        });
        await context.read<KidProgressService>().recordGameCompleted('bubbles', starsEarned: max(5, _score ~/ 2));
        if (!mounted) return;
        await KidAudioService.instance.success();
        _showResult();
      } else {
        setState(() => _timeLeft -= 1);
      }
    });
  }

  void _moveBubbleInternal() {
    _bubbleKey += 1;
    _alignment = Alignment(-0.78 + _random.nextDouble() * 1.56, -0.62 + _random.nextDouble() * 1.15);
    _size = 82 + _random.nextDouble() * 76;
    _color = _colors[_random.nextInt(_colors.length)];
  }

  Future<void> _popBubble() async {
    if (!_playing) return;
    await KidAudioService.instance.pop();
    if (!mounted) return;
    setState(() {
      _combo += 1;
      _score += _combo >= 5 ? 2 : 1;
      _moveBubbleInternal();
    });
  }

  Future<void> _showResult() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Text('🫧', style: TextStyle(fontSize: 54)),
        title: const Text('وقت رائع!'),
        content: Text('جمعت $_score نقطة ونجوماً جديدة.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('حسناً')),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _start();
            },
            child: const Text('مرة أخرى'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فقاعات النجوم')),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFBDEAFF), Color(0xFFF5EAFF), Colors.white]),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 18,
            right: 18,
            child: Row(
              children: [
                Expanded(child: _ScorePill(emoji: '⭐', label: '$_score', color: KidPalette.sunshine)),
                const SizedBox(width: 10),
                Expanded(child: _ScorePill(emoji: '🔥', label: '$_combo', color: KidPalette.coral)),
                const SizedBox(width: 10),
                Expanded(child: _ScorePill(emoji: '⏱️', label: '$_timeLeft', color: KidPalette.sky)),
              ],
            ),
          ),
          if (_playing)
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              alignment: _alignment,
              child: GestureDetector(
                onTap: _popBubble,
                child: AnimatedContainer(
                  key: ValueKey(_bubbleKey),
                  duration: const Duration(milliseconds: 170),
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withValues(alpha: 0.92), _color.withValues(alpha: 0.78)]),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.92), width: 5),
                    boxShadow: [BoxShadow(color: _color.withValues(alpha: 0.35), blurRadius: 30, spreadRadius: 6)],
                  ),
                  child: const Icon(Icons.star_rounded, size: 48, color: Colors.white),
                ),
              ),
            ),
          if (!_playing)
            Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [BoxShadow(color: KidPalette.navy.withValues(alpha: 0.13), blurRadius: 24, offset: const Offset(0, 10))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🫧', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 12),
                    const Text('المس الفقاعات بسرعة', textAlign: TextAlign.center, style: TextStyle(color: KidPalette.navy, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    const Text('لديك 30 ثانية. التتابع يمنحك نقاطاً إضافية.', textAlign: TextAlign.center, style: TextStyle(color: KidPalette.navy, height: 1.45, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 20),
                    FilledButton.icon(onPressed: _start, icon: const Icon(Icons.play_arrow_rounded), label: const Text('ابدأ اللعب')),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.emoji, required this.label, required this.color});
  final String emoji;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}
