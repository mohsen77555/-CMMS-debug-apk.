import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class ToddlerAudioService {
  ToddlerAudioService._();

  static final ToddlerAudioService instance = ToddlerAudioService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String fileName) async {
    try {
      await HapticFeedback.lightImpact();
      await _player.stop();
      await _player.play(
        AssetSource('audio/toddler/$fileName'),
        volume: 0.92,
      );
    } catch (_) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();
}
