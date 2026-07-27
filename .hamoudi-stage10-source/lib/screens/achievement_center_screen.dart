import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/kid_progress_service.dart';
import '../theme/app_theme.dart';

class AchievementCenterScreen extends StatelessWidget {
  const AchievementCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<KidProgressService>();
    final badges = <_BadgeData>[
      _BadgeData('أول نجمة', 'حصلت على أول نجمة', '⭐', progress.unlockedFirstStar),
      _BadgeData('عشر إجابات', 'أجبت عن 10 أسئلة', '🧠', progress.unlockedTenAnswers),
      _BadgeData('بطل الألعاب', 'أكملت 5 ألعاب', '🎮', progress.unlockedGameHero),
      _BadgeData('ثلاثة أيام', 'تعلمت 3 أيام متتالية', '🔥', progress.unlockedStreak),
      _BadgeData('مئة نجمة', 'جمعت 100 نجمة', '🏆', progress.unlockedHundredStars),
      _BadgeData('متعلم شامل', 'جربت كل فئات التعلم', '🌈', progress.unlockedAllRounder),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('إنجازاتي')),
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
                gradient: const LinearGradient(colors: [KidPalette.sky, KidPalette.lavender]),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: KidPalette.navy.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 58)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress.levelTitle,
                          style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'المستوى ${progress.level} • ${progress.stars} نجمة',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progress.levelProgress,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(10),
                          color: KidPalette.sunshine,
                          backgroundColor: Colors.white30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _SummaryCard(emoji: '🔥', value: '${progress.currentStreak}', label: 'أيام متتالية', color: KidPalette.coral)),
                const SizedBox(width: 10),
                Expanded(child: _SummaryCard(emoji: '✅', value: '${progress.correctAnswers}', label: 'إجابات صحيحة', color: KidPalette.mint)),
                const SizedBox(width: 10),
                Expanded(child: _SummaryCard(emoji: '🎮', value: '${progress.gamesPlayed}', label: 'ألعاب مكتملة', color: KidPalette.lavender)),
              ],
            ),
            const SizedBox(height: 22),
            const Text('شاراتي', style: TextStyle(color: KidPalette.navy, fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: badges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final badge = badges[index];
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: badge.unlocked ? Colors.white : const Color(0xFFF0F3F5),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: badge.unlocked ? KidPalette.sunshine : const Color(0xFFDCE5EA),
                      width: badge.unlocked ? 3 : 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(badge.unlocked ? badge.emoji : '🔒', style: const TextStyle(fontSize: 42)),
                      const SizedBox(height: 8),
                      Text(
                        badge.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: badge.unlocked ? KidPalette.navy : Colors.blueGrey,
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        badge.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.blueGrey, fontSize: 12, height: 1.25),
                      ),
                    ],
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.emoji, required this.value, required this.label, required this.color});
  final String emoji;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 27)),
          Text(value, style: const TextStyle(color: KidPalette.navy, fontSize: 22, fontWeight: FontWeight.w900)),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: KidPalette.navy, fontSize: 10.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _BadgeData {
  const _BadgeData(this.title, this.description, this.emoji, this.unlocked);
  final String title;
  final String description;
  final String emoji;
  final bool unlocked;
}
