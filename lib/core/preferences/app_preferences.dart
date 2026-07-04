import 'package:shared_preferences/shared_preferences.dart';

import '../constants/preference_keys.dart';

/// Thin, typed wrapper around [SharedPreferences] for the app's non-relational
/// settings (theme, language, currency, onboarding flag). Registered as a
/// singleton so every consumer reads and writes the same store.
class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static Future<AppPreferences> create() async {
    return AppPreferences(await SharedPreferences.getInstance());
  }

  bool get hasCompletedOnboarding =>
      _prefs.getBool(PreferenceKeys.hasCompletedOnboarding) ?? false;

  Future<void> setOnboardingCompleted() =>
      _prefs.setBool(PreferenceKeys.hasCompletedOnboarding, true);

  String? get themeMode => _prefs.getString(PreferenceKeys.themeMode);

  Future<void> setThemeMode(String value) =>
      _prefs.setString(PreferenceKeys.themeMode, value);

  String? get languageCode => _prefs.getString(PreferenceKeys.languageCode);

  Future<void> setLanguageCode(String value) =>
      _prefs.setString(PreferenceKeys.languageCode, value);

  String? get roundingMode => _prefs.getString(PreferenceKeys.roundingMode);

  Future<void> setRoundingMode(String value) =>
      _prefs.setString(PreferenceKeys.roundingMode, value);
}
