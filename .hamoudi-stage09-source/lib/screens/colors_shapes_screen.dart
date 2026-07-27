import 'package:flutter/material.dart';

class ColorsShapesScreen extends StatefulWidget {
  const ColorsShapesScreen({super.key});

  @override
  State<ColorsShapesScreen> createState() => _ColorsShapesScreenState();
}

class _ColorsShapesScreenState extends State<ColorsShapesScreen> {
  int _index = 0;

  static const _cards = [
    _ShapeCardData('أحمر', 'دائرة', Color(0xFFE75252), BoxShape.circle),
    _ShapeCardData('أزرق', 'مربع', Color(0xFF4B74D8), BoxShape.rectangle),
    _ShapeCardData('أصفر', 'دائرة', Color(0xFFF0C94A), BoxShape.circle),
    _ShapeCardData('أخضر', 'مربع', Color(0xFF59A96A), BoxShape.rectangle),
    _ShapeCardData('برتقالي', 'دائرة', Color(0xFFE98B3A), BoxShape.circle),
    _ShapeCardData('بنفسجي', 'مربع', Color(0xFF8A63C7), BoxShape.rectangle),
  ];

  void _next() {
    setState(() => _index = (_index + 1) % _cards.length);
  }

  @override
  Widget build(BuildContext context) {
    final card = _cards[_index];

    return Scaffold(
      appBar: AppBar(title: const Text('الألوان والأشكال')),
      body: InkWell(
        onTap: _next,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: Container(
                  key: ValueKey(_index),
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: card.color,
                    shape: card.shape,
                    borderRadius: card.shape == BoxShape.rectangle
                        ? BorderRadius.circular(34)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: card.color.withValues(alpha: 0.35),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 42),
              Text(
                card.colorName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                card.shapeName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 34),
              const Chip(
                avatar: Icon(Icons.touch_app_rounded),
                label: Text('المس للبطاقة التالية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShapeCardData {
  const _ShapeCardData(
    this.colorName,
    this.shapeName,
    this.color,
    this.shape,
  );

  final String colorName;
  final String shapeName;
  final Color color;
  final BoxShape shape;
}
