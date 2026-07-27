import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/kid_audio_service.dart';
import '../services/kid_progress_service.dart';
import '../theme/app_theme.dart';

class ShapeSorterGameScreen extends StatefulWidget {
  const ShapeSorterGameScreen({super.key});

  @override
  State<ShapeSorterGameScreen> createState() => _ShapeSorterGameScreenState();
}

class _ShapeSorterGameScreenState extends State<ShapeSorterGameScreen> {
  final Random _random = Random();

  static const _shapes = <_ShapeItem>[
    _ShapeItem('دائرة', Icons.circle_rounded, KidPalette.sky),
    _ShapeItem('مربع', Icons.square_rounded, KidPalette.coral),
    _ShapeItem('مثلث', Icons.change_history_rounded, KidPalette.sunshine),
    _ShapeItem('نجمة', Icons.star_rounded, KidPalette.lavender),
    _ShapeItem('قلب', Icons.favorite_rounded, KidPalette.pink),
  ];

  late _ShapeItem _target;
  late List<_ShapeItem> _choices;
  int _round = 1;
  int _score = 0;
  int _wrong = 0;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  void _newRound() {
    final shuffled = List<_ShapeItem>.from(_shapes)..shuffle(_random);
    _target = shuffled.first;
    _choices = <_ShapeItem>[_target, ...shuffled.skip(1).take(2)]..shuffle(_random);
  }

  Future<void> _handleDrop(_ShapeItem item) async {
    if (_locked) return;
    _locked = true;
    if (item.name == _target.name) {
      await KidAudioService.instance.success();
      await context.read<KidProgressService>().recordCorrect('shape_sorter', starsEarned: 3);
      if (!mounted) return;
      setState(() => _score += 1);
      if (_round >= 8) {
        await context.read<KidProgressService>().recordGameCompleted('shape_sorter', starsEarned: 14);
        if (!mounted) return;
        await _showComplete();
        return;
      }
      setState(() {
        _round += 1;
        _newRound();
        _locked = false;
      });
    } else {
      await KidAudioService.instance.wrong();
      if (!mounted) return;
      setState(() {
        _wrong += 1;
        _locked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جرّب شكلاً آخر 💛'), duration: Duration(milliseconds: 550)),
      );
    }
  }

  Future<void> _showComplete() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Text('🌈', style: TextStyle(fontSize: 58)),
        title: const Text('رائع يا بطل!'),
        content: Text('وضعت $_score أشكال صحيحة.\nالمحاولات الإضافية: $_wrong', textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('العودة'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() {
                _round = 1;
                _score = 0;
                _wrong = 0;
                _locked = false;
                _newRound();
              });
            },
            child: const Text('مرة أخرى'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رتّب الأشكال')),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF8FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
          children: [
            Row(
              children: [
                Expanded(child: _StatCard(emoji: '⭐', value: '$_score', label: 'نقاط', color: KidPalette.sunshine)),
                const SizedBox(width: 10),
                Expanded(child: _StatCard(emoji: '🎯', value: '$_round/8', label: 'الجولة', color: KidPalette.mint)),
                const SizedBox(width: 10),
                Expanded(child: _StatCard(emoji: '💛', value: '$_wrong', label: 'محاولات', color: KidPalette.peach)),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _round / 8,
              minHeight: 11,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 22),
            const Text(
              'اسحب الشكل إلى مكانه الصحيح',
              textAlign: TextAlign.center,
              style: TextStyle(color: KidPalette.navy, fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 18),
            DragTarget<_ShapeItem>(
              onWillAcceptWithDetails: (_) => !_locked,
              onAcceptWithDetails: (details) => _handleDrop(details.data),
              builder: (context, candidateData, rejectedData) {
                final active = candidateData.isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 230,
                  decoration: BoxDecoration(
                    color: active
                        ? _target.color.withValues(alpha: 0.23)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(38),
                    border: Border.all(
                      color: active ? _target.color : _target.color.withValues(alpha: 0.45),
                      width: active ? 5 : 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: KidPalette.navy.withValues(alpha: 0.11),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _target.icon,
                        size: 108,
                        color: _target.color.withValues(alpha: 0.28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'مكان ${_target.name}',
                        style: const TextStyle(
                          color: KidPalette.navy,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _choices.map((shape) {
                return Draggable<_ShapeItem>(
                  data: shape,
                  feedback: Material(
                    color: Colors.transparent,
                    child: _ShapeChip(shape: shape, large: true),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.25,
                    child: _ShapeChip(shape: shape),
                  ),
                  child: _ShapeChip(shape: shape),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShapeChip extends StatelessWidget {
  const _ShapeChip({required this.shape, this.large = false});
  final _ShapeItem shape;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 112.0 : 92.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: shape.color,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: shape.color.withValues(alpha: 0.34),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Icon(shape.icon, color: Colors.white, size: large ? 68 : 54),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.emoji, required this.value, required this.label, required this.color});
  final String emoji;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 23)),
          Text(value, style: const TextStyle(color: KidPalette.navy, fontSize: 19, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: KidPalette.navy, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ShapeItem {
  const _ShapeItem(this.name, this.icon, this.color);
  final String name;
  final IconData icon;
  final Color color;
}
