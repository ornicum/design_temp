import 'package:flutter/material.dart';

class AppTheme {
  // --- ЦВЕТА СТРОГОГО ТЕМНОГО НЕОНА (.dark в CSS) ---
  static const Color darkBg = Color(0xFF090E1A);
  static const Color darkCard = Color(0xFF0D1527);
  static const Color darkSidebar = Color(0xFF0A101F);
  static const Color neonCyan = Color(0xFF09DAEC);
  static const Color darkFg = Color(0xFFF1F5F9);
  static const Color darkMuted = Color(0xFF64748B);
  static const Color darkBorder = Color(0xFF1E293B);

  // --- ЦВЕТА СВЕТЛОЙ ТЕМЫ (:root в CSS) ---
  static const Color lightBg = Color(0xFFF1F3F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSidebar = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF097E96);
  static const Color lightFg = Color(0xFF0F172A);
  static const Color lightMuted = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFCBD5E1);

  // Общие семантические цвета
  static const Color destructive = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Константы обратной совместимости (дефолт - темный)
  static const Color background = darkBg;
  static const Color card = darkCard;
  static const Color primary = neonCyan;
  static const Color border = darkBorder;
  static const Color foreground = darkFg;
  static const Color mutedForeground = darkMuted;

  // --- УМНЫЙ ДИНАМИЧЕСКИЙ КОНТЕКСТ ---
  static bool isDark(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark;

  static Color bg(BuildContext c) =>
      isDark(c) ? darkBg : lightBg;

  static Color surface(BuildContext c) =>
      isDark(c) ? darkCard : lightCard;

  static Color sidebar(BuildContext c) =>
      isDark(c) ? darkSidebar : lightSidebar;

  static Color brand(BuildContext c) =>
      isDark(c) ? neonCyan : lightPrimary;

  static Color txt(BuildContext c) =>
      isDark(c) ? darkFg : lightFg;

  static Color txtMuted(BuildContext c) =>
      isDark(c) ? darkMuted : lightMuted;

  static Color bd(BuildContext c) =>
      isDark(c) ? darkBorder : lightBorder;

  // Моноширинный финтех-шрифт для цифр и пар
  static TextStyle monoStyle({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontFamily: 'JetBrains Mono',
    );
  }

  // --- НАСТРОЙКА СИСТЕМНЫХ ТЕМ ДЛЯ MATERIALAPP ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      dividerColor: darkBorder,
      colorScheme: const ColorScheme.dark(
        surface: darkCard,
        primary: neonCyan,
        onPrimary: darkBg,
        outline: darkBorder,
        error: destructive,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      cardColor: lightCard,
      dividerColor: lightBorder,
      colorScheme: const ColorScheme.light(
        surface: lightCard,
        primary: lightPrimary,
        onPrimary: Colors.white,
        outline: lightBorder,
        error: destructive,
      ),
    );
  }
}
