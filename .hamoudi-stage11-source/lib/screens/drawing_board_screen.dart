import 'package:flutter/material.dart';

import '../services/kid_audio_service.dart';
import '../theme/app_theme.dart';

class DrawingBoardScreen extends StatefulWidget {
  const DrawingBoardScreen({super.key});

  @override
  State<DrawingBoardScreen> createState() => _DrawingBoardScreenState();
}

class _DrawingBoardScreenState extends State<DrawingBoardScreen> {
  final List<_Stroke> _strokes = <_Stroke>[];
  Color _selectedColor = KidPalette.sky;
  double _strokeWidth = 8;

  static const _colors = <Color>[
    KidPalette.sky,
    KidPalette.coral,
    KidPalette.sunshine,
    KidPalette.mint,
    KidPalette.lavender,
    KidPalette.pink,
    Color(0xFF263238),
    Colors.white,
  ];

  void _startStroke(Offset point) {
    setState(() {
      _strokes.add(
        _Stroke(
          color: _selectedColor,
          width: _strokeWidth,
          points: <Offset>[point],
        ),
      );
    });
  }

  void _appendPoint(Offset point) {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.last.points.add(point));
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    KidAudioService.instance.tap();
    setState(() => _strokes.removeLast());
  }

  Future<void> _clear() async {
    if (_strokes.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Text('🎨', style: TextStyle(fontSize: 48)),
        title: const Text('مسح اللوحة؟'),
        content: const Text('سيتم حذف الرسم الحالي فقط.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await KidAudioService.instance.magic();
      setState(_strokes.clear);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة حمودي'),
        actions: [
          IconButton(
            onPressed: _undo,
            tooltip: 'تراجع',
            icon: const Icon(Icons.undo_rounded),
          ),
          IconButton(
            onPressed: _clear,
            tooltip: 'مسح',
            icon: const Icon(Icons.delete_sweep_rounded),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF8FF), Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: KidPalette.sky.withValues(alpha: 0.22)),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _colors.map((color) {
                          final selected = color == _selectedColor;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                KidAudioService.instance.tap();
                                setState(() => _selectedColor = color);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                width: selected ? 46 : 40,
                                height: selected ? 46 : 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected ? KidPalette.navy : const Color(0xFFDCEAF2),
                                    width: selected ? 4 : 2,
                                  ),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color: color.withValues(alpha: 0.35),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.brush_rounded, color: KidPalette.navy),
                        Expanded(
                          child: Slider(
                            value: _strokeWidth,
                            min: 3,
                            max: 24,
                            divisions: 7,
                            onChanged: (value) => setState(() => _strokeWidth = value),
                          ),
                        ),
                        Container(
                          width: _strokeWidth + 10,
                          height: _strokeWidth + 10,
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFEF8),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: KidPalette.navy.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (details) => _startStroke(details.localPosition),
                        onPanUpdate: (details) => _appendPoint(details.localPosition),
                        child: CustomPaint(
                          painter: _DrawingPainter(_strokes),
                          child: _strokes.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('✏️', style: TextStyle(fontSize: 60)),
                                      SizedBox(height: 10),
                                      Text(
                                        'ارسم هنا بإصبعك',
                                        style: TextStyle(
                                          color: KidPalette.navy,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.expand(),
                        ),
                      );
                    },
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

class _Stroke {
  _Stroke({required this.color, required this.width, required this.points});
  final Color color;
  final double width;
  final List<Offset> points;
}

class _DrawingPainter extends CustomPainter {
  const _DrawingPainter(this.strokes);
  final List<_Stroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (stroke.points.length == 1) {
        canvas.drawCircle(stroke.points.first, stroke.width / 2, paint..style = PaintingStyle.fill);
        continue;
      }

      final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (final point in stroke.points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
