import 'dart:math';

import 'package:flutter/material.dart';

import '../services/kid_audio_service.dart';
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
  late _LearningItem _target;
  late List<_LearningItem> _options;

  static const Map<LearningCategory, List<_LearningItem>> data = {
    LearningCategory.letters: [
      _LearningItem('ألف', 'أ', KidPalette.coral),
      _LearningItem('باء', 'ب', KidPalette.sky),
      _LearningItem('تاء', 'ت', KidPalette.mint),
      _LearningItem('جيم', 'ج', KidPalette.lavender),
      _LearningItem('ميم', 'م', KidPalette.sunshine),
      _LearningItem('نون', 'ن', KidPalette.pink),
    ],
    LearningCategory.numbers: [
      _LearningItem('واحد', '١', KidPalette.coral),
      _LearningItem('اثنان', '٢', KidPalette.sky),
      _LearningItem('ثلاثة', '٣', KidPalette.mint),
      _LearningItem('أربعة', '٤', KidPalette.lavender),
      _LearningItem('خمسة', '٥', KidPalette.sunshine),
      _LearningItem('ستة', '٦', KidPalette.pink),
    ],
    LearningCategory.colors: [
      _LearningItem('أحمر', '●', Color(0xFFFF625B)),
      _LearningItem('أزرق', '●', Color(0xFF3AAAF4)),
      _LearningItem('أخضر', '●', Color(0xFF4FD09A)),
      _LearningItem('أصفر', '●', Color(0xFFFFC93F)),
      _LearningItem('بنفسجي', '●', Color(0xFFA777E8)),
      _LearningItem('وردي', '●', Color(0xFFF58DA9)),
    ],
    LearningCategory.animals: [
      _LearningItem('أسد', '🦁', KidPalette.peach),
      _LearningItem('قطة', '🐱', KidPalette.pink),
      _LearningItem('كلب', '🐶', KidPalette.sky),
      _LearningItem('فيل', '🐘', KidPalette.lavender),
      _LearningItem('بطة', '🦆', KidPalette.sunshine),
      _LearningItem('سمكة', '🐟', KidPalette.mint),
    ],
    LearningCategory.fruits: [
      _LearningItem('تفاحة', '🍎', KidPalette.coral),
      _LearningItem('موزة', '🍌', KidPalette.sunshine),
      _LearningItem('عنب', '🍇', KidPalette.lavender),
      _LearningItem('فراولة', '🍓', KidPalette.pink),
      _LearningItem('برتقال', '🍊', KidPalette.peach),
      _LearningItem('بطيخ', '🍉', KidPalette.mint),
    ],
    LearningCategory.shapes: [
      _LearningItem('دائرة', '●', KidPalette.sky),
      _LearningItem('مربع', '■', KidPalette.coral),
      _LearningItem('مثلث', '▲', KidPalette.sunshine),
      _LearningItem('نجمة', '★', KidPalette.lavender),
      _LearningItem('قلب', '♥', KidPalette.pink),
      _LearningItem('بيضاوي', '⬭', KidPalette.mint),
    ],
  };

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  void _newRound() {
    final items = List<_LearningItem>.from(data[widget.category]!);
    items.shuffle(_random);
    _options = items.take(4).toList();
    _target = _options[_random.nextInt(_options.length)];
  }

  Future<void> _select(_LearningItem item) async {
    if (item.label == _target.label) {
      await KidAudioService.instance.success();
      if (!mounted) return;
      setState(() {
        _score++;
        _newRound();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أحسنت! إجابة صحيحة ⭐'), duration: Duration(milliseconds: 700)),
      );
    } else {
      await KidAudioService.instance.wrong();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حاول مرة أخرى 💛'), duration: Duration(milliseconds: 600)),
      );
    }
  }

  String get title {
    switch (widget.category) {
      case LearningCategory.letters: return 'الحروف';
      case LearningCategory.numbers: return 'الأرقام';
      case LearningCategory.colors: return 'الألوان';
      case LearningCategory.animals: return 'الحيوانات';
      case LearningCategory.fruits: return 'الفواكه';
      case LearningCategory.shapes: return 'الأشكال';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFEAF8FF), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0B9),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 8),
                      Text('نقاطك: $_score', style: const TextStyle(color: KidPalette.navy, fontSize: 20, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('اختر الإجابة الصحيحة', style: TextStyle(color: KidPalette.navy, fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(_target.label, style: const TextStyle(color: KidPalette.skyDark, fontSize: 34, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = _options[index];
                return Material(
                  color: item.color,
                  borderRadius: BorderRadius.circular(30),
                  elevation: 6,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => _select(item),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.symbol, style: TextStyle(fontSize: widget.category == LearningCategory.colors ? 78 : 62, color: widget.category == LearningCategory.colors ? item.color : Colors.white, fontWeight: FontWeight.w900, shadows: const [Shadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))])),
                        const SizedBox(height: 8),
                        Text(item.label, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
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
