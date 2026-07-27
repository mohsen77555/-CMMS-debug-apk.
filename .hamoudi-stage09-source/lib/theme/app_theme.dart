import 'package:flutter/material.dart';

class KidPalette {
  static const sky = Color(0xFF43B7F5);
  static const skyDark = Color(0xFF137CCB);
  static const sunshine = Color(0xFFFFC845);
  static const mint = Color(0xFF72DDB1);
  static const coral = Color(0xFFFF8C75);
  static const peach = Color(0xFFFFB487);
  static const lavender = Color(0xFFB994F5);
  static const pink = Color(0xFFF68DA6);
  static const navy = Color(0xFF14548C);
  static const cloud = Color(0xFFF8FCFF);
  static const cream = Color(0xFFFFF7DA);
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: KidPalette.sky,
      brightness: Brightness.light,
      primary: KidPalette.skyDark,
      secondary: KidPalette.sunshine,
      tertiary: KidPalette.coral,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF4FBFF),
      fontFamily: null,
      textTheme: ThemeData.light().textTheme.apply(
            bodyColor: const Color(0xFF174E7A),
            displayColor: const Color(0xFF174E7A),
          ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF174E7A),
        titleTextStyle: TextStyle(
          color: Color(0xFF174E7A),
          fontSize: 23,
          fontWeight: FontWeight.w900,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFD7EFFC), width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: KidPalette.sky, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 78,
        backgroundColor: Colors.white,
        elevation: 12,
        indicatorColor: KidPalette.sky.withValues(alpha: 0.18),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 11.5,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w900
                : FontWeight.w700,
            color: states.contains(WidgetState.selected)
                ? KidPalette.skyDark
                : const Color(0xFF43667F),
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: KidPalette.sky.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
        side: const BorderSide(color: Color(0xFFD7EFFC)),
      ),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: KidPalette.sky,
      brightness: Brightness.dark,
      primary: const Color(0xFF77CCFF),
      secondary: KidPalette.sunshine,
      tertiary: KidPalette.coral,
      surface: const Color(0xFF10273A),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF0C2030),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 78,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }
}
