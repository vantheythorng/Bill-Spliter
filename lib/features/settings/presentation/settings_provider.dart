import 'package:flutter/material.dart';

import '../../../core/preferences/app_preferences.dart';
import '../../../shared/utils/rounding_mode.dart';
import '../../../shared/utils/app_language.dart';

/// App-wide reactive settings: theme mode, language and split rounding. Changes
/// are persisted to [AppPreferences] and broadcast to listeners immediately, so
/// the UI updates the moment a setting changes.
///
/// Currency is intentionally *not* here — it is chosen per bill in the create
/// flow and stored on the bill record.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._prefs)
      : _themeMode = _parseThemeMode(_prefs.themeMode),
        _language = AppLanguage.fromCode(_prefs.languageCode),
        _roundingMode = RoundingMode.fromStorage(_prefs.roundingMode);

  final AppPreferences _prefs;

  ThemeMode _themeMode;
  AppLanguage _language;
  RoundingMode _roundingMode;

  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;
  Locale get locale => _language.locale;
  RoundingMode get roundingMode => _roundingMode;

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

  Future<void> setRoundingMode(RoundingMode mode) async {
    if (mode == _roundingMode) return;
    _roundingMode = mode;
    notifyListeners();
    await _prefs.setRoundingMode(mode.storageValue);
  }

  static ThemeMode _parseThemeMode(String? value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
