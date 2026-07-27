import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/kid_audio_service.dart';
import '../services/kid_progress_service.dart';
import '../theme/app_theme.dart';

class MemoryPairsGameScreen extends StatefulWidget {
  const MemoryPairsGameScreen({super.key});

  @override
  State<MemoryPairsGameScreen> createState() => _MemoryPairsGameScreenState();
}

class _MemoryPairsGameScreenState extends State<MemoryPairsGameScreen> {
  final Random _random = Random();
  Timer? _timer;
  late List<_PairCard> _cards;
  int? _firstIndex;
  bool _busy = false;
  int _moves = 0;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    const symbols = ['🦁', '🍎', '⭐', '🚗', '🐟', '🌈'];
    final selected = List<String>.from(symbols)..shuffle(_random);
    final values = <String>[...selected.take(3), ...selected.take(3)]..shuffle(_random);
    _cards = values.map((symbol) => _PairCard(symbol: symbol)).toList(growable: false);
    _firstIndex = null;
    _busy = false;
    _moves = 0;
    _seconds = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds += 1);
    });
  }

  Future<void> _tapCard(int index) async {
    if (_busy || _cards[index].matched || _cards[index].visible) return;
    setState(() => _cards[index].visible = true);
    await KidAudioService.instance.tap();

    if (_firstIndex == null) {
      _firstIndex = index;
      return;
    }

    final first = _firstIndex!;
    _firstIndex = null;
    _moves += 1;

    if (_cards[first].symbol == _cards[index].symbol) {
      setState(() {
        _cards[first].matched = true;
        _cards[index].matched = true;
      });
      await KidAudioService.instance.success();
      await context.read<KidProgressService>().recordCorrect('memory_pairs', starsEarned: 3);
      if (_cards.every((card) => card.matched)) {
        _timer?.cancel();
        await context.read<KidProgressService>().recordGameCompleted('memory_pairs', starsEarned: 14);
        if (!mounted) return;
        await _complete();
      }
      return;
    }

    _busy = true;
    await KidAudioService.instance.wrong();
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _cards[first].visible = false;
      _cards[index].visible = false;
      _busy = false;
    });
  }

  Future<void> _complete() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Text('🏆', style: TextStyle(fontSize: 54)),
        title: const Text('ذاكرتك ممتازة!'),
        content: Text('أكملت اللعبة في $_moves محاولات و$_seconds ثانية.'),
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
              setState(_newGame);
            },
            child: const Text('إعادة اللعب'),
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
    final matched = _cards.where((card) => card.matched).length ~/ 2;
    return Scaffold(
      appBar: AppBar(title: const Text('لعبة الذاكرة')),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFEAF8FF), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
          children: [
            Row(
              children: [
                Expanded(child: _InfoChip(icon: Icons.timer_rounded, text: '$_seconds ثانية', color: KidPalette.sky)),
                const SizedBox(width: 10),
                Expanded(child: _InfoChip(icon: Icons.touch_app_rounded, text: '$_moves محاولة', color: KidPalette.lavender)),
                const SizedBox(width: 10),
                Expanded(child: _InfoChip(icon: Icons.star_rounded, text: '$matched/3', color: KidPalette.sunshine)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('ابحث عن الصور المتشابهة', textAlign: TextAlign.center, style: TextStyle(color: KidPalette.navy, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final card = _cards[index];
                final revealed = card.visible || card.matched;
                return GestureDetector(
                  onTap: () => _tapCard(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: revealed ? [Colors.white, KidPalette.cream] : [KidPalette.lavender, KidPalette.sky],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: card.matched ? KidPalette.mint : Colors.white, width: card.matched ? 5 : 3),
                      boxShadow: [BoxShadow(color: KidPalette.navy.withValues(alpha: 0.13), blurRadius: 14, offset: const Offset(0, 8))],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: Text(
                          revealed ? card.symbol : '؟',
                          key: ValueKey(revealed),
                          style: TextStyle(fontSize: revealed ? 72 : 54, color: revealed ? null : Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Icon(icon, color: KidPalette.navy),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w800, fontSize: 11)),
        ],
      ),
    );
  }
}

class _PairCard {
  _PairCard({required this.symbol});
  final String symbol;
  bool visible = false;
  bool matched = false;
}
