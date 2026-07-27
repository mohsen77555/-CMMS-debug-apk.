import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class KidAudioService {
  KidAudioService._();

  static final KidAudioService instance = KidAudioService._();
  final AudioPlayer _player = AudioPlayer();

  Future<void> tap() => _play('audio/tap.wav', haptic: false);
  Future<void> success() => _play('audio/success.wav');
  Future<void> sparkle() => _play('audio/sparkle.wav');
  Future<void> pop() => _play('audio/pop.wav');
  Future<void> wrong() => _play('audio/wrong.wav');
  Future<void> bell() => _play('audio/bell.wav');

  Future<void> _play(String path, {bool haptic = true}) async {
    try {
      if (haptic) {
        await HapticFeedback.lightImpact();
      }
      await _player.stop();
      await _player.play(AssetSource(path), volume: 0.7);
    } catch (_) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  Future<void> dispose() => _player.dispose();
}
