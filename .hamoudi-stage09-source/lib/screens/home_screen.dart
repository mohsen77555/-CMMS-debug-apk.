import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/memory_provider.dart';
import '../services/kid_audio_service.dart';
import '../theme/app_theme.dart';
import 'children_screen.dart';
import 'future_letters_screen.dart';
import 'games_hub_screen.dart';
import 'memories_screen.dart';
import 'memory_book_screen.dart';
import 'on_this_day_screen.dart';
import 'sound_playground_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemoryProvider>();
    final profile = provider.profile;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF43B7F5), Color(0xFFEAF8FF), Color(0xFFF8FCFF)],
          stops: [0, 0.36, 1],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
            sliver: SliverToBoxAdapter(
              child: _TopHeader(
                childName: profile.name,
                onProfileTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const ChildrenScreen()),
                  );
                },
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
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 110),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate.fixed([
                _HomeTile(
                  title: 'ذكرياتي',
                  icon: Icons.collections_bookmark_rounded,
                  background: KidPalette.mint,
                  accent: const Color(0xFF237F61),
                  onTap: () => _open(context, const MemoriesScreen()),
                ),
                _HomeTile(
                  title: 'في مثل\nهذا اليوم',
                  icon: Icons.calendar_month_rounded,
                  background: KidPalette.sky,
                  accent: Colors.white,
                  onTap: () => _open(context, const OnThisDayScreen()),
                ),
                _HomeTile(
                  title: 'ألعابي\nالتعليمية',
                  icon: Icons.toys_rounded,
                  background: KidPalette.lavender,
                  accent: Colors.white,
                  onTap: () => _open(context, const GamesHubScreen(showBackButton: true)),
                ),
                _HomeTile(
                  title: 'أصواتي',
                  icon: Icons.mic_rounded,
                  background: KidPalette.peach,
                  accent: const Color(0xFF8D3E27),
                  onTap: () => _open(context, const SoundPlaygroundScreen()),
                ),
                _HomeTile(
                  title: 'قصصي',
                  icon: Icons.auto_stories_rounded,
                  background: KidPalette.sunshine,
                  accent: const Color(0xFF7A5000),
                  onTap: () => _open(context, const FutureLettersScreen()),
                ),
                _HomeTile(
                  title: 'كتابي\nوصوري',
                  icon: Icons.photo_camera_back_rounded,
                  background: KidPalette.pink,
                  accent: Colors.white,
                  onTap: () => _open(context, const MemoryBookScreen()),
                ),
              ]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.18,
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

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.childName, required this.onProfileTap});

  final String childName;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundButton(
          icon: Icons.notifications_rounded,
          badge: '3',
          onTap: KidAudioService.instance.bell,
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              'حمودي',
              style: TextStyle(
                color: KidPalette.sunshine,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(color: Colors.white.withValues(alpha: 0.95), blurRadius: 3),
                  Shadow(color: KidPalette.navy.withValues(alpha: 0.25), blurRadius: 9, offset: const Offset(0, 4)),
                ],
              ),
            ),
            Text(
              'عالم $childName الصغير',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const Spacer(),
        _RoundButton(
          icon: Icons.star_rounded,
          iconColor: KidPalette.sunshine,
          onTap: onProfileTap,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
    this.iconColor = KidPalette.sky,
    this.badge,
  });

  final IconData icon;
  final Color iconColor;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
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
        ),
        if (badge != null)
          Positioned(
            top: -5,
            left: -5,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Color(0xFFFF665B), shape: BoxShape.circle),
              child: Text(
                badge!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
              ),
            ),
          ),
      ],
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
      decoration: BoxDecoration(
        color: const Color(0xFFFFE7A8),
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
      clipBehavior: Clip.antiAlias,
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
            top: 64,
            left: 172,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك يا $name!',
                  style: const TextStyle(
                    color: KidPalette.navy,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'جاهزين نلعب، نتعلم،\nونحفظ أجمل الذكريات؟',
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

class _HomeTile extends StatelessWidget {
  const _HomeTile({
    required this.title,
    required this.icon,
    required this.background,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color background;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(30),
      elevation: 7,
      shadowColor: KidPalette.navy.withValues(alpha: 0.16),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: Icon(icon, color: accent.withValues(alpha: 0.94), size: 64),
              ),
              Positioned(
                right: 0,
                top: 0,
                left: 52,
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: accent,
                    fontSize: 22,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    shadows: [Shadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 5, offset: const Offset(0, 2))],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Icon(Icons.auto_awesome_rounded, color: Colors.white.withValues(alpha: 0.75), size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
