import 'package:flutter/material.dart';

import '../services/kid_audio_service.dart';
import '../theme/app_theme.dart';
import 'bubble_game_screen.dart';
import 'learning_cards_game_screen.dart';
import 'sound_playground_screen.dart';

class GamesHubScreen extends StatelessWidget {
  const GamesHubScreen({this.showBackButton = false, super.key});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    const games = <_GameDefinition>[
      _GameDefinition('الحروف', 'أ ب ت', Icons.text_fields_rounded, KidPalette.mint, LearningCategory.letters),
      _GameDefinition('الأرقام', '١ ٢ ٣', Icons.pin_rounded, KidPalette.sky, LearningCategory.numbers),
      _GameDefinition('الألوان', '🎨', Icons.palette_rounded, KidPalette.lavender, LearningCategory.colors),
      _GameDefinition('الحيوانات', '🦁', Icons.pets_rounded, KidPalette.peach, LearningCategory.animals),
      _GameDefinition('الفواكه', '🍎', Icons.apple_rounded, KidPalette.sunshine, LearningCategory.fruits),
      _GameDefinition('الأشكال', '🔺', Icons.category_rounded, KidPalette.mint, LearningCategory.shapes),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF43B7F5), Color(0xFFEAF8FF), Color(0xFFF8FCFF)],
          stops: [0, 0.32, 1],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
            sliver: SliverToBoxAdapter(
              child: _GamesHeader(showBackButton: showBackButton),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverToBoxAdapter(child: _ProgressCard()),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            sliver: SliverGrid.builder(
              itemCount: games.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.18,
              ),
              itemBuilder: (context, index) {
                final game = games[index];
                return _GameCard(
                  game: game,
                  onTap: () {
                    KidAudioService.instance.tap();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => LearningCardsGameScreen(category: game.category),
                      ),
                    );
                  },
                );
              },
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
                      subtitle: 'اضغط واستمع',
                      icon: Icons.mic_rounded,
                      color: KidPalette.pink,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const SoundPlaygroundScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _WideGameCard(
                      title: 'فقاعات',
                      subtitle: 'المس واجمع النجوم',
                      icon: Icons.bubble_chart_rounded,
                      color: KidPalette.lavender,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const BubbleGameScreen()),
                      ),
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
}

class _GamesHeader extends StatelessWidget {
  const _GamesHeader({required this.showBackButton});
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),
          Positioned(
            right: 18,
            top: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('ألعابي', style: TextStyle(color: KidPalette.skyDark, fontSize: 34, fontWeight: FontWeight.w900)),
                Text('التعليمية', style: TextStyle(color: KidPalette.sunshine, fontSize: 32, fontWeight: FontWeight.w900)),
                SizedBox(height: 8),
                Text('نلعب ونتعلم خطوة بخطوة ⭐', style: TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Positioned(
            left: 4,
            bottom: -26,
            child: Image.asset('assets/icon/hamoodi_icon.jpg', width: 174, height: 174, fit: BoxFit.cover),
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
  const _ProgressCard();

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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مستواك مميز!', style: TextStyle(color: KidPalette.navy, fontSize: 19, fontWeight: FontWeight.w900)),
                SizedBox(height: 7),
                LinearProgressIndicator(value: 0.72, minHeight: 10, borderRadius: BorderRadius.all(Radius.circular(12))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text('36/50', style: TextStyle(color: KidPalette.skyDark, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _GameDefinition {
  const _GameDefinition(this.title, this.symbol, this.icon, this.color, this.category);
  final String title;
  final String symbol;
  final IconData icon;
  final Color color;
  final LearningCategory category;
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game, required this.onTap});
  final _GameDefinition game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: game.color,
      borderRadius: BorderRadius.circular(28),
      elevation: 6,
      shadowColor: KidPalette.navy.withValues(alpha: 0.16),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Text(game.title, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
              Positioned(bottom: 0, right: 0, child: Icon(game.icon, color: Colors.white.withValues(alpha: 0.78), size: 55)),
              Positioned(bottom: 5, left: 3, child: Text(game.symbol, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900))),
              const Positioned(top: 3, left: 3, child: Icon(Icons.star_rounded, color: KidPalette.sunshine, size: 22)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideGameCard extends StatelessWidget {
  const _WideGameCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
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
          padding: const EdgeInsets.all(17),
          child: Column(
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 9),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
