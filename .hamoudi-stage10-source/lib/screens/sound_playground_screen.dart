import 'package:flutter/material.dart';

import '../services/kid_audio_service.dart';
import '../theme/app_theme.dart';

class SoundPlaygroundScreen extends StatefulWidget {
  const SoundPlaygroundScreen({super.key});

  @override
  State<SoundPlaygroundScreen> createState() => _SoundPlaygroundScreenState();
}

class _SoundPlaygroundScreenState extends State<SoundPlaygroundScreen> {
  late bool _soundEnabled;
  late bool _hapticEnabled;
  late double _volume;

  @override
  void initState() {
    super.initState();
    _soundEnabled = KidAudioService.instance.soundEnabled;
    _hapticEnabled = KidAudioService.instance.hapticEnabled;
    _volume = KidAudioService.instance.volume;
  }

  @override
  Widget build(BuildContext context) {
    final sounds = <_SoundCard>[
      _SoundCard('نجمة', '⭐', KidPalette.sunshine, KidAudioService.instance.sparkle),
      _SoundCard('جرس', '🔔', KidPalette.sky, KidAudioService.instance.bell),
      _SoundCard('فقاعة', '🫧', KidPalette.lavender, KidAudioService.instance.pop),
      _SoundCard('تصفيق', '👏', KidPalette.mint, KidAudioService.instance.success),
      _SoundCard('قطة', '🐱', KidPalette.pink, KidAudioService.instance.cat),
      _SoundCard('كلب', '🐶', KidPalette.peach, KidAudioService.instance.dog),
      _SoundCard('عصفور', '🐦', KidPalette.sky, KidAudioService.instance.bird),
      _SoundCard('قطار', '🚂', KidPalette.coral, KidAudioService.instance.train),
      _SoundCard('طبلة', '🥁', KidPalette.sunshine, KidAudioService.instance.drum),
      _SoundCard('ضحكة', '😄', KidPalette.mint, KidAudioService.instance.laugh),
      _SoundCard('سحر', '✨', KidPalette.lavender, KidAudioService.instance.magic),
      _SoundCard('قلب', '💗', KidPalette.pink, KidAudioService.instance.tap),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('أصواتي الممتعة')),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFEAF8FF), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: KidPalette.sky.withValues(alpha: 0.22)),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('تشغيل الأصوات', style: TextStyle(fontWeight: FontWeight.w900)),
                        secondary: const Icon(Icons.volume_up_rounded, color: KidPalette.sky),
                        value: _soundEnabled,
                        onChanged: (value) async {
                          await KidAudioService.instance.setSoundEnabled(value);
                          if (mounted) setState(() => _soundEnabled = value);
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('اهتزاز لطيف', style: TextStyle(fontWeight: FontWeight.w900)),
                        secondary: const Icon(Icons.vibration_rounded, color: KidPalette.lavender),
                        value: _hapticEnabled,
                        onChanged: (value) async {
                          await KidAudioService.instance.setHapticEnabled(value);
                          if (mounted) setState(() => _hapticEnabled = value);
                        },
                      ),
                      Row(
                        children: [
                          const Icon(Icons.volume_down_rounded, color: KidPalette.navy),
                          Expanded(
                            child: Slider(
                              value: _volume,
                              onChanged: _soundEnabled ? (value) => setState(() => _volume = value) : null,
                              onChangeEnd: (value) => KidAudioService.instance.setVolume(value),
                            ),
                          ),
                          const Icon(Icons.volume_up_rounded, color: KidPalette.navy),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 36),
              sliver: SliverGrid.builder(
                itemCount: sounds.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 13,
                  mainAxisSpacing: 13,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final sound = sounds[index];
                  return Material(
                    color: sound.color,
                    borderRadius: BorderRadius.circular(30),
                    elevation: 6,
                    shadowColor: KidPalette.navy.withValues(alpha: 0.14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _soundEnabled ? sound.onTap : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(sound.emoji, style: const TextStyle(fontSize: 54)),
                          const SizedBox(height: 8),
                          Text(sound.title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Icon(_soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded, color: Colors.white),
                        ],
                      ),
                    ),
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

class _SoundCard {
  const _SoundCard(this.title, this.emoji, this.color, this.onTap);
  final String title;
  final String emoji;
  final Color color;
  final Future<void> Function() onTap;
}
