import 'package:flutter/material.dart';

/// ألوان وسمات التطبيق (فاتح وداكن).
class AppTheme {
  static const primary = Color(0xFF0288D1);
  static const primaryDark = Color(0xFF4FC3F7);

  // خلفيات الوضع الفاتح.
  static const lightBg = Color(0xFFF5FBFF);
  static const lightCard = Colors.white;
  static const lightBorder = Color(0xFFE1F5FE);

  // خلفيات الوضع الداكن.
  static const darkBg = Color(0xFF0E1621);
  static const darkCard = Color(0xFF16202C);
  static const darkBorder = Color(0xFF24323F);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: lightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(backgroundColor: primary),
      ),
      cardColor: lightCard,
      dividerColor: lightBorder,
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ).copyWith(surface: darkCard, primary: primaryDark);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCard,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            backgroundColor: primaryDark, foregroundColor: Colors.black),
      ),
      cardColor: darkCard,
      dividerColor: darkBorder,
    );
  }

  // مساعدات حسب السطوع الحالي.
  static Color bg(BuildContext c) =>
      _isDark(c) ? darkBg : lightBg;
  static Color card(BuildContext c) =>
      _isDark(c) ? darkCard : lightCard;
  static Color border(BuildContext c) =>
      _isDark(c) ? darkBorder : lightBorder;
  static Color accent(BuildContext c) =>
      _isDark(c) ? primaryDark : primary;
  static Color softText(BuildContext c) =>
      _isDark(c) ? Colors.white60 : Colors.black54;

  static bool _isDark(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark;
}
