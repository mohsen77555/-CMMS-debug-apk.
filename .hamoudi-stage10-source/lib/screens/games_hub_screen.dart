import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/kid_audio_service.dart';
import '../services/kid_progress_service.dart';
import '../theme/app_theme.dart';
import 'achievement_center_screen.dart';
import 'bubble_game_screen.dart';
import 'learning_cards_game_screen.dart';
import 'matching_game_screen.dart';
import 'memory_pairs_game_screen.dart';
import 'sound_playground_screen.dart';

class GamesHubScreen extends StatelessWidget {
  const GamesHubScreen({this.showBackButton = false, super.key});
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    const games = <_GameDefinition>[
      _GameDefinition('الحروف', 'أ ب ت', Icons.text_fields_rounded, KidPalette.mint, LearningCategory.letters, 'letters'),
      _GameDefinition('الأرقام', '١ ٢ ٣', Icons.pin_rounded, KidPalette.sky, LearningCategory.numbers, 'numbers'),
      _GameDefinition('الألوان', '🎨', Icons.palette_rounded, KidPalette.lavender, LearningCategory.colors, 'colors'),
      _GameDefinition('الحيوانات', '🦁', Icons.pets_rounded, KidPalette.peach, LearningCategory.animals, 'animals'),
      _GameDefinition('الفواكه', '🍎', Icons.apple_rounded, KidPalette.sunshine, LearningCategory.fruits, 'fruits'),
      _GameDefinition('الأشكال', '🔺', Icons.category_rounded, KidPalette.mint, LearningCategory.shapes, 'shapes'),
    ];
    final progress = context.watch<KidProgressService>();

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF43B7F5), Color(0xFFEAF8FF), Color(0xFFF8FCFF)],
          stops: [0, 0.30, 1],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
            sliver: SliverToBoxAdapter(
              child: _GamesHeader(
                showBackButton: showBackButton,
                onAchievements: () => _open(context, const AchievementCenterScreen()),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverToBoxAdapter(child: _ProgressCard(progress: progress)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            sliver: SliverGrid.builder(
              itemCount: games.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.12,
              ),
              itemBuilder: (context, index) {
                final game = games[index];
                return _GameCard(
                  game: game,
                  wins: progress.winsFor(game.keyName),
                  onTap: () => _open(context, LearningCardsGameScreen(category: game.category)),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: _WideGameCard(
                      title: 'طابق الصورة',
                      subtitle: 'صورة وكلمة',
                      emoji: '🧩',
                      color: KidPalette.coral,
                      progress: progress.winsFor('matching'),
                      onTap: () => _open(context, const MatchingGameScreen()),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _WideGameCard(
                      title: 'لعبة الذاكرة',
                      subtitle: 'ابحث عن الأزواج',
                      emoji: '🧠',
                      color: KidPalette.sky,
                      progress: progress.winsFor('memory_pairs'),
                      onTap: () => _open(context, const MemoryPairsGameScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: _WideGameCard(
                      title: 'أصوات ممتعة',
                      subtitle: '12 صوتاً',
                      emoji: '🎤',
                      color: KidPalette.pink,
                      progress: 0,
                      onTap: () => _open(context, const SoundPlaygroundScreen()),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _WideGameCard(
                      title: 'فقاعات النجوم',
                      subtitle: '30 ثانية',
                      emoji: '🫧',
                      color: KidPalette.lavender,
                      progress: progress.winsFor('bubbles'),
                      onTap: () => _open(context, const BubbleGameScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _open(BuildContext context, Widget screen) {
    KidAudioService.instance.tap();
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _GamesHeader extends StatelessWidget {
  const _GamesHeader({required this.showBackButton, required this.onAchievements});
  final bool showBackButton;
  final VoidCallback onAchievements;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),
          const Positioned(
            right: 18,
            top: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ألعابي', style: TextStyle(color: KidPalette.skyDark, fontSize: 34, fontWeight: FontWeight.w900)),
                Text('التعليمية', style: TextStyle(color: KidPalette.sunshine, fontSize: 32, fontWeight: FontWeight.w900)),
                SizedBox(height: 8),
                Text('تعلّم جديد ومكافآت أكثر ⭐', style: TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Positioned(
            left: 4,
            bottom: -26,
            child: Image.asset('assets/icon/hamoodi_icon.jpg', width: 174, height: 174, fit: BoxFit.cover),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: KidPalette.sunshine, foregroundColor: Colors.white),
              onPressed: onAchievements,
              tooltip: 'الإنجازات',
              icon: const Icon(Icons.emoji_events_rounded),
            ),
          ),
          if (showBackButton)
            Positioned(
              left: 12,
              top: 12,
              child: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: KidPalette.skyDark),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.progress});
  final KidProgressService progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0B9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [BoxShadow(color: KidPalette.navy.withValues(alpha: 0.12), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 27, backgroundColor: Colors.white, child: Text('⭐', style: TextStyle(fontSize: 30))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${progress.levelTitle} • المستوى ${progress.level}', style: const TextStyle(color: KidPalette.navy, fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 7),
                LinearProgressIndicator(
                  value: progress.levelProgress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(12),
                  color: KidPalette.mint,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 5),
                Text('بقي ${progress.starsToNextLevel} نجمة للمستوى التالي', style: const TextStyle(color: KidPalette.navy, fontSize: 11.5, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text('${progress.stars}', style: const TextStyle(color: KidPalette.skyDark, fontSize: 21, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _GameDefinition {
  const _GameDefinition(this.title, this.symbol, this.icon, this.color, this.category, this.keyName);
  final String title;
  final String symbol;
  final IconData icon;
  final Color color;
  final LearningCategory category;
  final String keyName;
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game, required this.wins, required this.onTap});
  final _GameDefinition game;
  final int wins;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progressValue = (wins / 30).clamp(0.0, 1.0);
    return Material(
      color: game.color,
      borderRadius: BorderRadius.circular(28),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Stack(
            children: [
              Text(game.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
              Positioned(bottom: 31, right: 0, child: Icon(game.icon, color: Colors.white.withValues(alpha: 0.78), size: 48)),
              Positioned(bottom: 31, left: 3, child: Text(game.symbol, style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w900))),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Expanded(child: LinearProgressIndicator(value: progressValue, minHeight: 7, borderRadius: BorderRadius.circular(8), color: Colors.white, backgroundColor: Colors.white30)),
                    const SizedBox(width: 7),
                    Text('$wins', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideGameCard extends StatelessWidget {
  const _WideGameCard({required this.title, required this.subtitle, required this.emoji, required this.color, required this.progress, required this.onTap});
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final int progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(28),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 46)),
              const SizedBox(height: 7),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontWeight: FontWeight.w700, fontSize: 12)),
              if (progress > 0) ...[
                const SizedBox(height: 7),
                Text('$progress نقطة', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
