import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KidProgressService extends ChangeNotifier {
  KidProgressService._();

  static final KidProgressService instance = KidProgressService._();

  static const _starsKey = 'kid_progress_stars';
  static const _correctKey = 'kid_progress_correct_answers';
  static const _gamesKey = 'kid_progress_games_played';
  static const _streakKey = 'kid_progress_current_streak';
  static const _bestStreakKey = 'kid_progress_best_streak';
  static const _lastPlayKey = 'kid_progress_last_play';
  static const _categoriesKey = 'kid_progress_categories';

  bool isReady = false;
  int stars = 0;
  int correctAnswers = 0;
  int gamesPlayed = 0;
  int currentStreak = 0;
  int bestStreak = 0;
  DateTime? lastPlayDate;
  Map<String, int> categoryWins = <String, int>{};

  int get level => 1 + (stars ~/ 50);
  int get starsIntoLevel => stars % 50;
  int get starsToNextLevel => 50 - starsIntoLevel;
  double get levelProgress => starsIntoLevel / 50;

  String get levelTitle {
    if (level >= 10) return 'بطل المعرفة';
    if (level >= 7) return 'نجم لامع';
    if (level >= 4) return 'متعلم رائع';
    return 'مستكشف صغير';
  }

  int winsFor(String category) => categoryWins[category] ?? 0;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    stars = prefs.getInt(_starsKey) ?? 0;
    correctAnswers = prefs.getInt(_correctKey) ?? 0;
    gamesPlayed = prefs.getInt(_gamesKey) ?? 0;
    currentStreak = prefs.getInt(_streakKey) ?? 0;
    bestStreak = prefs.getInt(_bestStreakKey) ?? 0;

    final lastPlayValue = prefs.getString(_lastPlayKey);
    if (lastPlayValue != null && lastPlayValue.isNotEmpty) {
      lastPlayDate = DateTime.tryParse(lastPlayValue);
    }

    final categoriesValue = prefs.getString(_categoriesKey);
    if (categoriesValue != null) {
      try {
        final decoded = jsonDecode(categoriesValue);
        if (decoded is Map<String, dynamic>) {
          categoryWins = decoded.map(
            (key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0),
          );
        }
      } catch (_) {
        categoryWins = <String, int>{};
      }
    }

    _normalizeStreak();
    isReady = true;
    notifyListeners();
  }

  Future<void> recordCorrect(
    String category, {
    int starsEarned = 2,
  }) async {
    _touchPlayDay();
    correctAnswers += 1;
    stars += starsEarned;
    categoryWins[category] = winsFor(category) + 1;
    await _save();
    notifyListeners();
  }

  Future<void> recordGameCompleted(
    String category, {
    int starsEarned = 8,
  }) async {
    _touchPlayDay();
    gamesPlayed += 1;
    stars += starsEarned;
    categoryWins[category] = winsFor(category) + 3;
    await _save();
    notifyListeners();
  }

  bool get unlockedFirstStar => stars >= 1;
  bool get unlockedTenAnswers => correctAnswers >= 10;
  bool get unlockedGameHero => gamesPlayed >= 5;
  bool get unlockedStreak => bestStreak >= 3;
  bool get unlockedHundredStars => stars >= 100;
  bool get unlockedAllRounder =>
      const ['letters', 'numbers', 'colors', 'animals', 'fruits', 'shapes']
          .every((key) => winsFor(key) > 0);

  void _normalizeStreak() {
    final last = lastPlayDate;
    if (last == null) return;
    final today = _dateOnly(DateTime.now());
    final played = _dateOnly(last);
    if (today.difference(played).inDays > 1) {
      currentStreak = 0;
    }
  }

  void _touchPlayDay() {
    final today = _dateOnly(DateTime.now());
    final last = lastPlayDate == null ? null : _dateOnly(lastPlayDate!);
    if (last == today) return;

    if (last != null && today.difference(last).inDays == 1) {
      currentStreak += 1;
    } else {
      currentStreak = 1;
    }
    if (currentStreak > bestStreak) {
      bestStreak = currentStreak;
    }
    lastPlayDate = today;
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt(_starsKey, stars),
      prefs.setInt(_correctKey, correctAnswers),
      prefs.setInt(_gamesKey, gamesPlayed),
      prefs.setInt(_streakKey, currentStreak),
      prefs.setInt(_bestStreakKey, bestStreak),
      prefs.setString(_lastPlayKey, lastPlayDate?.toIso8601String() ?? ''),
      prefs.setString(_categoriesKey, jsonEncode(categoryWins)),
    ]);
  }
}
