import 'package:flutter/material.dart';

import '../services/kid_audio_service.dart';
import '../theme/app_theme.dart';

class SoundPlaygroundScreen extends StatelessWidget {
  const SoundPlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sounds = <_SoundCard>[
      _SoundCard('نجمة', '⭐', KidPalette.sunshine, KidAudioService.instance.sparkle),
      _SoundCard('جرس', '🔔', KidPalette.sky, KidAudioService.instance.bell),
      _SoundCard('فقاعة', '🫧', KidPalette.lavender, KidAudioService.instance.pop),
      _SoundCard('نجاح', '👏', KidPalette.mint, KidAudioService.instance.success),
      _SoundCard('قلب', '💗', KidPalette.pink, KidAudioService.instance.tap),
      _SoundCard('مفاجأة', '🎉', KidPalette.coral, KidAudioService.instance.sparkle),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('أصواتي الممتعة')),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFEAF8FF), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
          itemCount: sounds.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final sound = sounds[index];
            return Material(
              color: sound.color,
              borderRadius: BorderRadius.circular(30),
              elevation: 7,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () { sound.onTap(); },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(sound.emoji, style: const TextStyle(fontSize: 58)),
                    const SizedBox(height: 10),
                    Text(sound.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    const Icon(Icons.volume_up_rounded, color: Colors.white),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SoundCard {
  const _SoundCard(this.title, this.emoji, this.color, this.onTap);
  final String title;
  final String emoji;
  final Color color;
  final Future<void> Function() onTap;
}
