import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/memory_provider.dart';
import '../services/kid_audio_service.dart';
import '../services/kid_progress_service.dart';
import '../theme/app_theme.dart';
import 'achievement_center_screen.dart';
import 'children_screen.dart';
import 'drawing_board_screen.dart';
import 'future_letters_screen.dart';
import 'games_hub_screen.dart';
import 'memories_screen.dart';
import 'memory_book_screen.dart';
import 'on_this_day_screen.dart';
import 'parent_progress_screen.dart';
import 'shape_sorter_game_screen.dart';
import 'sound_playground_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final memory = context.watch<MemoryProvider>();
    final progress = context.watch<KidProgressService>();
    final profile = memory.profile;

    final tiles = <_HomeTileData>[
      _HomeTileData(
        title: 'ذكرياتي',
        subtitle: '${memory.memories.length} لحظة',
        icon: Icons.collections_bookmark_rounded,
        emoji: '📸',
        background: KidPalette.mint,
        onTap: () => _open(context, const MemoriesScreen()),
      ),
      _HomeTileData(
        title: 'في مثل هذا اليوم',
        subtitle: '${memory.onThisDayMemories.length} ذكرى',
        icon: Icons.calendar_month_rounded,
        emoji: '🎈',
        background: KidPalette.sky,
        onTap: () => _open(context, const OnThisDayScreen()),
      ),
      _HomeTileData(
        title: 'ألعابي التعليمية',
        subtitle: '10 أنشطة',
        icon: Icons.toys_rounded,
        emoji: '🎮',
        background: KidPalette.lavender,
        onTap: () => _open(context, const GamesHubScreen(showBackButton: true)),
      ),
      _HomeTileData(
        title: 'أصواتي',
        subtitle: '12 صوتاً',
        icon: Icons.mic_rounded,
        emoji: '🎤',
        background: KidPalette.peach,
        onTap: () => _open(context, const SoundPlaygroundScreen()),
      ),
      _HomeTileData(
        title: 'قصصي ورسائلي',
        subtitle: 'للمستقبل',
        icon: Icons.auto_stories_rounded,
        emoji: '📖',
        background: KidPalette.sunshine,
        onTap: () => _open(context, const FutureLettersScreen()),
      ),
      _HomeTileData(
        title: 'كتابي وصوري',
        subtitle: 'كتاب الذكريات',
        icon: Icons.photo_camera_back_rounded,
        emoji: '📚',
        background: KidPalette.pink,
        onTap: () => _open(context, const MemoryBookScreen()),
      ),
      _HomeTileData(
        title: 'لوحة الرسم',
        subtitle: 'ارسم بإصبعك',
        icon: Icons.brush_rounded,
        emoji: '🎨',
        background: KidPalette.coral,
        onTap: () => _open(context, const DrawingBoardScreen()),
      ),
      _HomeTileData(
        title: 'رتّب الأشكال',
        subtitle: 'اسحب وطابق',
        icon: Icons.extension_rounded,
        emoji: '🧩',
        background: KidPalette.mint,
        onTap: () => _open(context, const ShapeSorterGameScreen()),
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF43B7F5), Color(0xFFEAF8FF), Color(0xFFF8FCFF)],
          stops: [0, 0.33, 1],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
            sliver: SliverToBoxAdapter(
              child: _TopHeader(
                childName: profile.name,
                onProfileTap: () => _open(context, const ChildrenScreen()),
                onAchievementsTap: () => _open(context, const AchievementCenterScreen()),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverToBoxAdapter(
              child: _HeroBanner(name: profile.name),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            sliver: SliverToBoxAdapter(
              child: _LearningOverview(
                progress: progress,
                onProgressTap: () => _open(context, const ParentProgressScreen()),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
            sliver: SliverToBoxAdapter(
              child: _DailyMission(
                progress: progress,
                onTap: () => _open(context, const GamesHubScreen(showBackButton: true)),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 120),
            sliver: SliverGrid.builder(
              itemCount: tiles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 13,
                mainAxisSpacing: 13,
                childAspectRatio: 1.02,
              ),
              itemBuilder: (context, index) => _HomeTile(data: tiles[index]),
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

class _TopHeader extends StatelessWidget {
  const _TopHeader({
    required this.childName,
    required this.onProfileTap,
    required this.onAchievementsTap,
  });

  final String childName;
  final VoidCallback onProfileTap;
  final VoidCallback onAchievementsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundButton(
          icon: Icons.emoji_events_rounded,
          iconColor: KidPalette.sunshine,
          onTap: onAchievementsTap,
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              'حمودي',
              style: TextStyle(
                color: KidPalette.sunshine,
                fontSize: 38,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(color: Colors.white.withValues(alpha: 0.95), blurRadius: 3),
                  Shadow(
                    color: KidPalette.navy.withValues(alpha: 0.25),
                    blurRadius: 9,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Text(
              'عالم $childName الصغير',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const Spacer(),
        _RoundButton(
          icon: Icons.child_care_rounded,
          iconColor: KidPalette.skyDark,
          onTap: onProfileTap,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.iconColor, required this.onTap});
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 6,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: 52,
          child: Icon(icon, color: iconColor, size: 28),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFFF0B9), Color(0xFFFFDFA2)],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: [
          BoxShadow(
            color: KidPalette.navy.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(top: 12, right: 14, child: Text('🌈', style: TextStyle(fontSize: 44))),
          const Positioned(bottom: 14, right: 16, child: Text('💗', style: TextStyle(fontSize: 28))),
          const Positioned(top: 22, left: 20, child: Text('⭐', style: TextStyle(fontSize: 28))),
          Positioned(
            bottom: -4,
            left: -6,
            child: Image.asset(
              'assets/icon/hamoodi_icon.jpg',
              width: 205,
              height: 205,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 22,
            top: 61,
            left: 172,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً يا $name!',
                  style: const TextStyle(
                    color: KidPalette.navy,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'اليوم لدينا لعب، تعلم،\nولحظات جميلة جديدة.',
                  style: TextStyle(
                    color: KidPalette.navy,
                    fontSize: 15.5,
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningOverview extends StatelessWidget {
  const _LearningOverview({required this.progress, required this.onProgressTap});
  final KidProgressService progress;
  final VoidCallback onProgressTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      elevation: 4,
      shadowColor: KidPalette.navy.withValues(alpha: 0.13),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onProgressTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF0B9),
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Text('🏆', style: TextStyle(fontSize: 31))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${progress.levelTitle} • المستوى ${progress.level}',
                      style: const TextStyle(
                        color: KidPalette.navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    LinearProgressIndicator(
                      value: progress.levelProgress,
                      minHeight: 9,
                      borderRadius: BorderRadius.circular(10),
                      color: KidPalette.mint,
                      backgroundColor: KidPalette.mint.withValues(alpha: 0.16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${progress.stars} نجمة • ${progress.correctAnswers} إجابة صحيحة',
                      style: const TextStyle(
                        color: KidPalette.navy,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: KidPalette.sky),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyMission extends StatelessWidget {
  const _DailyMission({required this.progress, required this.onTap});
  final KidProgressService progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final missionIndex = DateTime.now().day % 4;
    final mission = switch (missionIndex) {
      0 => ('الحروف', 'أجب عن 5 أسئلة صحيحة', '🔤'),
      1 => ('الألوان', 'تعرف على 5 ألوان', '🎨'),
      2 => ('الذاكرة', 'أكمل جولة أزواج', '🧠'),
      _ => ('الأشكال', 'رتّب 5 أشكال', '🧩'),
    };

    return Material(
      color: KidPalette.coral,
      borderRadius: BorderRadius.circular(28),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(mission.$3, style: const TextStyle(fontSize: 46)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'مهمة اليوم',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${mission.$1}: ${mission.$2}',
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 38),
                  if (progress.currentStreak > 0)
                    Text(
                      '🔥 ${progress.currentStreak}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTileData {
  const _HomeTileData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.emoji,
    required this.background,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String emoji;
  final Color background;
  final VoidCallback onTap;
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({required this.data});
  final _HomeTileData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: data.background,
      borderRadius: BorderRadius.circular(30),
      elevation: 6,
      shadowColor: KidPalette.navy.withValues(alpha: 0.16),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Text(data.emoji, style: const TextStyle(fontSize: 38)),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Icon(data.icon, color: Colors.white.withValues(alpha: 0.34), size: 52),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                        shadows: [Shadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data.subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
