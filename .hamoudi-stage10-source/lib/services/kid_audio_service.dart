import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KidAudioService {
  KidAudioService._();

  static final KidAudioService instance = KidAudioService._();

  static const _soundKey = 'kid_audio_sound_enabled';
  static const _hapticKey = 'kid_audio_haptic_enabled';
  static const _volumeKey = 'kid_audio_volume';

  final AudioPlayer _player = AudioPlayer();

  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  double _volume = 0.78;

  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;
  double get volume => _volume;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool(_soundKey) ?? true;
    _hapticEnabled = prefs.getBool(_hapticKey) ?? true;
    _volume = (prefs.getDouble(_volumeKey) ?? 0.78).clamp(0.0, 1.0).toDouble();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, value);
    if (!value) await _player.stop();
  }

  Future<void> setHapticEnabled(bool value) async {
    _hapticEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticKey, value);
  }

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0).toDouble();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, _volume);
  }

  Future<void> tap() => _play('audio/tap.wav', haptic: false);
  Future<void> success() => _play('audio/success.wav');
  Future<void> sparkle() => _play('audio/sparkle.wav');
  Future<void> pop() => _play('audio/pop.wav');
  Future<void> wrong() => _play('audio/wrong.wav');
  Future<void> bell() => _play('audio/bell.wav');
  Future<void> cat() => _play('audio/cat.wav');
  Future<void> dog() => _play('audio/dog.wav');
  Future<void> bird() => _play('audio/bird.wav');
  Future<void> train() => _play('audio/train.wav');
  Future<void> drum() => _play('audio/drum.wav');
  Future<void> laugh() => _play('audio/laugh.wav');
  Future<void> magic() => _play('audio/magic.wav');

  Future<void> _play(String path, {bool haptic = true}) async {
    try {
      if (haptic && _hapticEnabled) {
        await HapticFeedback.lightImpact();
      }
      if (!_soundEnabled) return;
      await _player.stop();
      await _player.play(AssetSource(path), volume: _volume);
    } catch (_) {
      if (_soundEnabled) {
        await SystemSound.play(SystemSoundType.click);
      }
    }
  }

  Future<void> dispose() => _player.dispose();
}
