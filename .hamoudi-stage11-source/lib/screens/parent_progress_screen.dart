import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/kid_progress_service.dart';
import '../theme/app_theme.dart';

class ParentProgressScreen extends StatelessWidget {
  const ParentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<KidProgressService>();
    final categories = <_CategoryProgress>[
      _CategoryProgress('الحروف', 'letters', Icons.text_fields_rounded, KidPalette.mint),
      _CategoryProgress('الأرقام', 'numbers', Icons.pin_rounded, KidPalette.sky),
      _CategoryProgress('الألوان', 'colors', Icons.palette_rounded, KidPalette.lavender),
      _CategoryProgress('الحيوانات', 'animals', Icons.pets_rounded, KidPalette.peach),
      _CategoryProgress('الفواكه', 'fruits', Icons.apple_rounded, KidPalette.sunshine),
      _CategoryProgress('الأشكال', 'shapes', Icons.category_rounded, KidPalette.coral),
      _CategoryProgress('المطابقة', 'matching', Icons.extension_rounded, KidPalette.pink),
      _CategoryProgress('الذاكرة', 'memory_pairs', Icons.psychology_rounded, KidPalette.sky),
    ];

    final best = [...categories]
      ..sort((a, b) => progress.winsFor(b.keyName).compareTo(progress.winsFor(a.keyName)));
    final bestCategory = best.first;
    final bestValue = progress.winsFor(bestCategory.keyName);

    return Scaffold(
      appBar: AppBar(title: const Text('تقدم حمودي')),
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [KidPalette.skyDark, KidPalette.lavender],
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: KidPalette.navy.withValues(alpha: 0.15),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/icon/hamoodi_icon.jpg',
                        width: 82,
                        height: 82,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress.levelTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'المستوى ${progress.level} • ${progress.stars} نجمة',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progress.levelProgress,
                          minHeight: 10,
                          color: KidPalette.sunshine,
                          backgroundColor: Colors.white30,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _Summary(
                    emoji: '✅',
                    value: '${progress.correctAnswers}',
                    label: 'إجابة صحيحة',
                    color: KidPalette.mint,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Summary(
                    emoji: '🎮',
                    value: '${progress.gamesPlayed}',
                    label: 'لعبة مكتملة',
                    color: KidPalette.lavender,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Summary(
                    emoji: '🔥',
                    value: '${progress.bestStreak}',
                    label: 'أفضل تتابع',
                    color: KidPalette.coral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3C7),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bestValue == 0
                          ? 'ابدؤوا بنشاط قصير لمدة خمس دقائق، ثم شجعوه بعد كل محاولة.'
                          : 'أفضل نشاط حالياً: ${bestCategory.title}. كرروا النشاط مع تغيير بسيط للحفاظ على الحماس.',
                      style: const TextStyle(
                        color: KidPalette.navy,
                        height: 1.45,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'التقدم حسب النشاط',
              style: TextStyle(
                color: KidPalette.navy,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            ...categories.map((category) {
              final value = progress.winsFor(category.keyName);
              final normalized = (value / 30).clamp(0.0, 1.0).toDouble();
              return Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: category.color.withValues(alpha: 0.28)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: category.color.withValues(alpha: 0.22),
                        child: Icon(category.icon, color: KidPalette.navy),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    category.title,
                                    style: const TextStyle(
                                      color: KidPalette.navy,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$value نقطة',
                                  style: const TextStyle(
                                    color: KidPalette.skyDark,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: normalized,
                              minHeight: 8,
                              color: category.color,
                              backgroundColor: category.color.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KidPalette.mint.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_rounded, color: KidPalette.navy),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'بيانات التقدم محفوظة على الجهاز وتستخدم لتحسين تجربة التعلم داخل التطبيق.',
                      style: TextStyle(
                        color: KidPalette.navy,
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.emoji, required this.value, required this.label, required this.color});
  final String emoji;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          Text(
            value,
            style: const TextStyle(
              color: KidPalette.navy,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: KidPalette.navy,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProgress {
  const _CategoryProgress(this.title, this.keyName, this.icon, this.color);
  final String title;
  final String keyName;
  final IconData icon;
  final Color color;
}
