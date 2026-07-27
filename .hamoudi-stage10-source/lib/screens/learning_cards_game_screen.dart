import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/kid_audio_service.dart';
import '../services/kid_progress_service.dart';
import '../theme/app_theme.dart';

enum LearningCategory { letters, numbers, colors, animals, fruits, shapes }

class _LearningItem {
  const _LearningItem(this.label, this.symbol, this.color);
  final String label;
  final String symbol;
  final Color color;
}

class LearningCardsGameScreen extends StatefulWidget {
  const LearningCardsGameScreen({required this.category, super.key});
  final LearningCategory category;

  @override
  State<LearningCardsGameScreen> createState() => _LearningCardsGameScreenState();
}

class _LearningCardsGameScreenState extends State<LearningCardsGameScreen> {
  final Random _random = Random();
  int _score = 0;
  int _round = 1;
  int _streak = 0;
  int _mistakes = 0;
  bool _locked = false;
  late _LearningItem _target;
  late List<_LearningItem> _options;

  static const Map<LearningCategory, List<_LearningItem>> data = {
    LearningCategory.letters: [
      _LearningItem('ألف', 'أ', KidPalette.coral), _LearningItem('باء', 'ب', KidPalette.sky),
      _LearningItem('تاء', 'ت', KidPalette.mint), _LearningItem('ثاء', 'ث', KidPalette.peach),
      _LearningItem('جيم', 'ج', KidPalette.lavender), _LearningItem('حاء', 'ح', KidPalette.sunshine),
      _LearningItem('دال', 'د', KidPalette.pink), _LearningItem('راء', 'ر', KidPalette.sky),
      _LearningItem('ميم', 'م', KidPalette.mint), _LearningItem('نون', 'ن', KidPalette.lavender),
    ],
    LearningCategory.numbers: [
      _LearningItem('واحد', '١', KidPalette.coral), _LearningItem('اثنان', '٢', KidPalette.sky),
      _LearningItem('ثلاثة', '٣', KidPalette.mint), _LearningItem('أربعة', '٤', KidPalette.lavender),
      _LearningItem('خمسة', '٥', KidPalette.sunshine), _LearningItem('ستة', '٦', KidPalette.pink),
      _LearningItem('سبعة', '٧', KidPalette.peach), _LearningItem('ثمانية', '٨', KidPalette.sky),
      _LearningItem('تسعة', '٩', KidPalette.mint), _LearningItem('عشرة', '١٠', KidPalette.coral),
    ],
    LearningCategory.colors: [
      _LearningItem('أحمر', '●', Color(0xFFFF625B)), _LearningItem('أزرق', '●', Color(0xFF3AAAF4)),
      _LearningItem('أخضر', '●', Color(0xFF4FD09A)), _LearningItem('أصفر', '●', Color(0xFFFFC93F)),
      _LearningItem('بنفسجي', '●', Color(0xFFA777E8)), _LearningItem('وردي', '●', Color(0xFFF58DA9)),
      _LearningItem('برتقالي', '●', Color(0xFFFF9E4A)), _LearningItem('بني', '●', Color(0xFF9B6A45)),
      _LearningItem('أسود', '●', Color(0xFF263238)), _LearningItem('أبيض', '●', Color(0xFFF7F7F7)),
    ],
    LearningCategory.animals: [
      _LearningItem('أسد', '🦁', KidPalette.peach), _LearningItem('قطة', '🐱', KidPalette.pink),
      _LearningItem('كلب', '🐶', KidPalette.sky), _LearningItem('فيل', '🐘', KidPalette.lavender),
      _LearningItem('بطة', '🦆', KidPalette.sunshine), _LearningItem('سمكة', '🐟', KidPalette.mint),
      _LearningItem('أرنب', '🐰', KidPalette.pink), _LearningItem('حصان', '🐴', KidPalette.peach),
      _LearningItem('قرد', '🐵', KidPalette.coral), _LearningItem('فراشة', '🦋', KidPalette.sky),
    ],
    LearningCategory.fruits: [
      _LearningItem('تفاحة', '🍎', KidPalette.coral), _LearningItem('موزة', '🍌', KidPalette.sunshine),
      _LearningItem('عنب', '🍇', KidPalette.lavender), _LearningItem('فراولة', '🍓', KidPalette.pink),
      _LearningItem('برتقال', '🍊', KidPalette.peach), _LearningItem('بطيخ', '🍉', KidPalette.mint),
      _LearningItem('خوخ', '🍑', KidPalette.coral), _LearningItem('أناناس', '🍍', KidPalette.sunshine),
      _LearningItem('كرز', '🍒', KidPalette.pink), _LearningItem('كمثرى', '🍐', KidPalette.mint),
    ],
    LearningCategory.shapes: [
      _LearningItem('دائرة', '●', KidPalette.sky), _LearningItem('مربع', '■', KidPalette.coral),
      _LearningItem('مثلث', '▲', KidPalette.sunshine), _LearningItem('نجمة', '★', KidPalette.lavender),
      _LearningItem('قلب', '♥', KidPalette.pink), _LearningItem('بيضاوي', '⬭', KidPalette.mint),
      _LearningItem('مستطيل', '▭', KidPalette.peach), _LearningItem('معين', '◆', KidPalette.sky),
      _LearningItem('هلال', '☾', KidPalette.lavender), _LearningItem('سهم', '➜', KidPalette.coral),
    ],
  };

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  void _newRound() {
    final items = List<_LearningItem>.from(data[widget.category]!)..shuffle(_random);
    _options = items.take(4).toList();
    _target = _options[_random.nextInt(_options.length)];
  }

  Future<void> _select(_LearningItem item) async {
    if (_locked) return;
    _locked = true;
    if (item.label == _target.label) {
      await KidAudioService.instance.success();
      await context.read<KidProgressService>().recordCorrect(categoryKey, starsEarned: _streak >= 2 ? 3 : 2);
      if (!mounted) return;
      setState(() {
        _score += 1;
        _streak += 1;
      });
      if (_round >= 10) {
        await context.read<KidProgressService>().recordGameCompleted(categoryKey, starsEarned: 10 + _score);
        if (!mounted) return;
        await _showCompletion();
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
        _mistakes += 1;
        _streak = 0;
        _locked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حاول مرة أخرى 💛'), duration: Duration(milliseconds: 550)));
    }
  }

  Future<void> _showCompletion() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Text('🌟', style: TextStyle(fontSize: 56)),
        title: const Text('أكملت عشر جولات!'),
        content: Text('الإجابات الصحيحة: $_score\nالمحاولات الإضافية: $_mistakes', textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () { Navigator.of(dialogContext).pop(); Navigator.of(context).pop(); }, child: const Text('العودة')),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() {
                _score = 0; _round = 1; _streak = 0; _mistakes = 0; _locked = false; _newRound();
              });
            },
            child: const Text('العب من جديد'),
          ),
        ],
      ),
    );
  }

  String get categoryKey => switch (widget.category) {
        LearningCategory.letters => 'letters', LearningCategory.numbers => 'numbers',
        LearningCategory.colors => 'colors', LearningCategory.animals => 'animals',
        LearningCategory.fruits => 'fruits', LearningCategory.shapes => 'shapes',
      };

  String get title => switch (widget.category) {
        LearningCategory.letters => 'الحروف', LearningCategory.numbers => 'الأرقام',
        LearningCategory.colors => 'الألوان', LearningCategory.animals => 'الحيوانات',
        LearningCategory.fruits => 'الفواكه', LearningCategory.shapes => 'الأشكال',
      };

  @override
  Widget build(BuildContext context) {
    final isColorGame = widget.category == LearningCategory.colors;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFEAF8FF), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 36),
          children: [
            Row(
              children: [
                Expanded(child: _RoundPill(emoji: '⭐', text: '$_score', color: KidPalette.sunshine)),
                const SizedBox(width: 9),
                Expanded(child: _RoundPill(emoji: '🔥', text: '$_streak', color: KidPalette.coral)),
                const SizedBox(width: 9),
                Expanded(child: _RoundPill(emoji: '🎯', text: '$_round/10', color: KidPalette.mint)),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(value: _round / 10, minHeight: 11, borderRadius: BorderRadius.circular(12)),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(21),
              decoration: BoxDecoration(color: const Color(0xFFFFF0B9), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white, width: 4)),
              child: Column(
                children: [
                  const Text('اختر الإجابة الصحيحة', style: TextStyle(color: KidPalette.navy, fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(_target.label, style: const TextStyle(color: KidPalette.skyDark, fontSize: 34, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 13, mainAxisSpacing: 13, childAspectRatio: 1),
              itemBuilder: (context, index) {
                final item = _options[index];
                final background = isColorGame ? Colors.white : item.color;
                final foreground = isColorGame ? KidPalette.navy : Colors.white;
                return Material(
                  color: background,
                  borderRadius: BorderRadius.circular(30),
                  elevation: 6,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => _select(item),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.symbol, style: TextStyle(fontSize: isColorGame ? 78 : 60, color: isColorGame ? item.color : foreground, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Text(item.label, style: TextStyle(color: foreground, fontSize: 21, fontWeight: FontWeight.w900)),
                      ],
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

class _RoundPill extends StatelessWidget {
  const _RoundPill({required this.emoji, required this.text, required this.color});
  final String emoji;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(emoji, style: const TextStyle(fontSize: 20)), const SizedBox(width: 5), Text(text, style: const TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w900, fontSize: 17))],
      ),
    );
  }
}
