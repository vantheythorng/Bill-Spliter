import 'package:flutter/material.dart';

import '../../../core/preferences/app_preferences.dart';
import '../../../shared/utils/rounding_mode.dart';
import '../../../shared/utils/app_language.dart';

/// App-wide reactive settings: theme mode and language. Changes are persisted
/// to [AppPreferences] and broadcast to listeners immediately, so the UI
/// updates the moment a setting changes.
///
/// Split rounding is not configurable — the app uses largest-remainder
/// ([RoundingMode.largestRemainder]): shares are floored to the cent and the
/// indivisible leftover cent goes to one participant, so every split adds up to
/// exactly the bill total (no over-collection, no shortfall). In a settle-up
/// bill this means the person who fronted the cash pays the odd cent.
///
/// Currency is intentionally *not* here — it is chosen per bill in the create
/// flow and stored on the bill record.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._prefs)
      : _themeMode = _parseThemeMode(_prefs.themeMode),
        _language = AppLanguage.fromCode(_prefs.languageCode);

  final AppPreferences _prefs;

  ThemeMode _themeMode;
  AppLanguage _language;

  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;
  Locale get locale => _language.locale;

  /// Fixed app-wide rounding mode. Largest-remainder, so shares always sum to
  /// the exact bill total and one participant absorbs the odd cent.
  RoundingMode get roundingMode => RoundingMode.largestRemainder;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs.setThemeMode(mode.name);
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (language == _language) return;
    _language = language;
    notifyListeners();
    await _prefs.setLanguageCode(language.code);
  }

  static ThemeMode _parseThemeMode(String? value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
