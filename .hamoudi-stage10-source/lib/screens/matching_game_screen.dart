import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/kid_audio_service.dart';
import '../services/kid_progress_service.dart';
import '../theme/app_theme.dart';

class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  final Random _random = Random();
  static const _items = <_MatchItem>[
    _MatchItem('🦁', 'أسد'),
    _MatchItem('🐱', 'قطة'),
    _MatchItem('🐶', 'كلب'),
    _MatchItem('🍎', 'تفاحة'),
    _MatchItem('🍌', 'موزة'),
    _MatchItem('🚗', 'سيارة'),
    _MatchItem('⭐', 'نجمة'),
    _MatchItem('🌙', 'قمر'),
    _MatchItem('🐟', 'سمكة'),
    _MatchItem('🌸', 'زهرة'),
  ];

  late _MatchItem _target;
  late List<_MatchItem> _choices;
  int _round = 1;
  int _score = 0;
  int _streak = 0;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _prepareRound();
  }

  void _prepareRound() {
    final shuffled = List<_MatchItem>.from(_items)..shuffle(_random);
    _target = shuffled.first;
    _choices = <_MatchItem>[_target, ...shuffled.skip(1).take(2)]..shuffle(_random);
  }

  Future<void> _choose(_MatchItem item) async {
    if (_locked) return;
    _locked = true;
    if (item.word == _target.word) {
      await KidAudioService.instance.success();
      await context.read<KidProgressService>().recordCorrect('matching', starsEarned: 3);
      if (!mounted) return;
      setState(() {
        _score += 1;
        _streak += 1;
      });
      if (_round >= 8) {
        await context.read<KidProgressService>().recordGameCompleted('matching', starsEarned: 12);
        if (!mounted) return;
        await _showCompleteDialog();
        return;
      }
      setState(() {
        _round += 1;
        _prepareRound();
        _locked = false;
      });
    } else {
      await KidAudioService.instance.wrong();
      if (!mounted) return;
      setState(() => _streak = 0);
      _locked = false;
    }
  }

  Future<void> _showCompleteDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Text('🎉', style: TextStyle(fontSize: 52)),
        title: const Text('أحسنت يا بطل!'),
        content: Text('أكملت اللعبة وحصلت على $_score من 8.'),
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
                _streak = 0;
                _locked = false;
                _prepareRound();
              });
            },
            child: const Text('العب من جديد'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طابق الصورة بالكلمة')),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFEAF8FF), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
          children: [
            Row(
              children: [
                Expanded(child: _MiniStat(emoji: '⭐', label: 'النقاط', value: '$_score', color: KidPalette.sunshine)),
                const SizedBox(width: 10),
                Expanded(child: _MiniStat(emoji: '🔥', label: 'التتابع', value: '$_streak', color: KidPalette.coral)),
                const SizedBox(width: 10),
                Expanded(child: _MiniStat(emoji: '🎯', label: 'الجولة', value: '$_round/8', color: KidPalette.mint)),
              ],
            ),
            const SizedBox(height: 18),
            LinearProgressIndicator(value: _round / 8, minHeight: 11, borderRadius: BorderRadius.circular(12)),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2C2),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Column(
                children: [
                  const Text('ما اسم هذه الصورة؟', style: TextStyle(color: KidPalette.navy, fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(_target.emoji, key: ValueKey(_target.word), style: const TextStyle(fontSize: 104)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ..._choices.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  elevation: 3,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _choose(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                      child: Row(
                        children: [
                          const Icon(Icons.volume_up_rounded, color: KidPalette.sky),
                          const SizedBox(width: 12),
                          Expanded(child: Text(item.word, style: const TextStyle(color: KidPalette.navy, fontSize: 23, fontWeight: FontWeight.w900))),
                          const Icon(Icons.arrow_forward_ios_rounded, color: KidPalette.lavender),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.emoji, required this.label, required this.value, required this.color});
  final String emoji;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          Text(value, style: const TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w900, fontSize: 19)),
          Text(label, style: const TextStyle(color: KidPalette.navy, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _MatchItem {
  const _MatchItem(this.emoji, this.word);
  final String emoji;
  final String word;
}
