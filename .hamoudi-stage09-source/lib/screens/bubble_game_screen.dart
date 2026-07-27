import 'dart:math';

import 'package:flutter/material.dart';

class BubbleGameScreen extends StatefulWidget {
  const BubbleGameScreen({super.key});

  @override
  State<BubbleGameScreen> createState() => _BubbleGameScreenState();
}

class _BubbleGameScreenState extends State<BubbleGameScreen> {
  final _random = Random();
  int _score = 0;
  int _bubbleKey = 0;
  Alignment _alignment = Alignment.center;
  double _size = 120;

  @override
  void initState() {
    super.initState();
    _moveBubble();
  }

  void _moveBubble() {
    setState(() {
      _bubbleKey++;
      _alignment = Alignment(
        -0.75 + _random.nextDouble() * 1.5,
        -0.65 + _random.nextDouble() * 1.3,
      );
      _size = 90 + _random.nextDouble() * 80;
    });
  }

  void _popBubble() {
    setState(() => _score++);
    _moveBubble();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('فقاعات اللمس'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Center(
              child: Chip(
                avatar: const Icon(Icons.star_rounded, size: 20),
                label: Text('$_score'),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.primaryContainer.withValues(alpha: 0.45),
                    colors.tertiaryContainer.withValues(alpha: 0.38),
                  ],
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
            alignment: _alignment,
            child: Semantics(
              button: true,
              label: 'فقاعة كبيرة',
              child: GestureDetector(
                onTap: _popBubble,
                child: AnimatedContainer(
                  key: ValueKey(_bubbleKey),
                  duration: const Duration(milliseconds: 180),
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.primary.withValues(alpha: 0.72),
                        colors.tertiary.withValues(alpha: 0.72),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.75),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.25),
                        blurRadius: 28,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.touch_app_rounded,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 20,
            right: 20,
            bottom: 22,
            child: Text(
              'المس الفقاعة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
