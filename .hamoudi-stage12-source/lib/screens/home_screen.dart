import 'package:flutter/material.dart';

import '../services/kid_audio_service.dart';
import '../theme/app_theme.dart';
import 'memories_screen.dart';
import 'parent_progress_screen.dart';
import 'sound_playground_screen.dart';
import 'toddler_picture_sound_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = <_ToddlerHomeCard>[
      _ToddlerHomeCard(
        emoji: '🦁',
        secondaryEmoji: '🐘',
        color: KidPalette.mint,
        sound: KidAudioService.instance.cat,
        page: const ToddlerPictureSoundScreen(
          category: ToddlerCategory.animals,
        ),
      ),
      _ToddlerHomeCard(
        emoji: '🌈',
        secondaryEmoji: '🎨',
        color: KidPalette.sky,
        sound: KidAudioService.instance.sparkle,
        page: const ToddlerPictureSoundScreen(
          category: ToddlerCategory.colors,
        ),
      ),
      _ToddlerHomeCard(
        emoji: '🍎',
        secondaryEmoji: '🍌',
        color: KidPalette.sunshine,
        sound: KidAudioService.instance.success,
        page: const ToddlerPictureSoundScreen(
          category: ToddlerCategory.fruits,
        ),
      ),
      _ToddlerHomeCard(
        emoji: '⭐',
        secondaryEmoji: '🔺',
        color: KidPalette.lavender,
        sound: KidAudioService.instance.magic,
        page: const ToddlerPictureSoundScreen(
          category: ToddlerCategory.shapes,
        ),
      ),
      _ToddlerHomeCard(
        emoji: '🎤',
        secondaryEmoji: '🎵',
        color: KidPalette.peach,
        sound: KidAudioService.instance.drum,
        page: const SoundPlaygroundScreen(),
      ),
      _ToddlerHomeCard(
        emoji: '📸',
        secondaryEmoji: '💗',
        color: KidPalette.pink,
        sound: KidAudioService.instance.sparkle,
        page: const MemoriesScreen(),
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF072D57),
            Color(0xFF0F75C8),
            Color(0xFFBDEAFF),
            Color(0xFFF7FCFF),
          ],
          stops: [0, 0.31, 0.67, 1],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Material(
                      color: const Color(0xFF102B46),
                      shape: const CircleBorder(),
                      elevation: 5,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          KidAudioService.instance.tap();
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ParentProgressScreen(),
                            ),
                          );
                        },
                        child: const SizedBox.square(
                          dimension: 54,
                          child: Icon(
                            Icons.lock_rounded,
                            color: KidPalette.sunshine,
                            size: 29,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'حمودي',
                      style: TextStyle(
                        color: KidPalette.sunshine,
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.white.withValues(alpha: 0.68),
                            blurRadius: 4,
                          ),
                          const Shadow(
                            color: Color(0x66000000),
                            blurRadius: 12,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: KidPalette.sunshine,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon/hamoodi_icon.jpg',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: KidAudioService.instance.success,
                  child: Container(
                    height: 190,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF4C7), Color(0xFFFFD891)],
                      ),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4400264D),
                          blurRadius: 22,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        const Positioned(
                          top: 18,
                          left: 20,
                          child: Text('⭐', style: TextStyle(fontSize: 48)),
                        ),
                        const Positioned(
                          right: 24,
                          bottom: 22,
                          child: Text('☁️', style: TextStyle(fontSize: 62)),
                        ),
                        Positioned(
                          right: 8,
                          bottom: -20,
                          child: Image.asset(
                            'assets/icon/hamoodi_icon.jpg',
                            width: 194,
                            height: 194,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 28,
                          top: 56,
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF49C9FF), Color(0xFF0877E6)],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x55004C99),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 116),
              sliver: SliverGrid.builder(
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return _VisualActivityCard(
                    data: card,
                    onTap: () async {
                      await card.sound();
                      if (!context.mounted) return;
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => card.page),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisualActivityCard extends StatelessWidget {
  const _VisualActivityCard({required this.data, required this.onTap});

  final _ToddlerHomeCard data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: data.color,
      borderRadius: BorderRadius.circular(34),
      elevation: 7,
      shadowColor: const Color(0x4400264D),
      child: InkWell(
        borderRadius: BorderRadius.circular(34),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Stack(
            children: [
              Positioned(
                left: 7,
                top: 6,
                child: Text(
                  data.secondaryEmoji,
                  style: const TextStyle(fontSize: 39),
                ),
              ),
              Center(
                child: Text(
                  data.emoji,
                  style: const TextStyle(fontSize: 88),
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF49C9FF), Color(0xFF0877E6)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4400264D),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 37,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToddlerHomeCard {
  const _ToddlerHomeCard({
    required this.emoji,
    required this.secondaryEmoji,
    required this.color,
    required this.sound,
    required this.page,
  });

  final String emoji;
  final String secondaryEmoji;
  final Color color;
  final Future<void> Function() sound;
  final Widget page;
}
