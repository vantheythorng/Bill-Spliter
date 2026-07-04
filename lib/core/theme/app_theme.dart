import 'package:flutter/material.dart';

/// Single source of truth for the app's Material 3 themes. Light and dark are
/// both derived from the same [seedColor] so the palette stays consistent.
class AppTheme {
  const AppTheme._();

  static const Color seedColor = Color(0xFF2E7D6B);

  /// Font that carries Khmer glyphs. Kept as an app-wide fallback so Khmer text
  /// (e.g. a person's name) renders correctly even under the default font.
  static const String khmerFontFamily = 'Kantumruy Pro';

  static ThemeData light({String? fontFamily}) =>
      _themeFor(Brightness.light, fontFamily);
  static ThemeData dark({String? fontFamily}) =>
      _themeFor(Brightness.dark, fontFamily);

  static ThemeData _themeFor(Brightness brightness, String? fontFamily) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      fontFamilyFallback: const [khmerFontFamily],
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
