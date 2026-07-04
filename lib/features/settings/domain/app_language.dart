import 'package:flutter/widgets.dart';

/// Languages the app can display. English ships at launch; adding a locale here
/// (plus its ARB file) is all that a new language requires.
enum AppLanguage {
  english('en', 'English'),
  khmer('km', 'ខ្មែរ');

  const AppLanguage(this.code, this.displayName);

  final String code;
  final String displayName;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }

  static List<Locale> get supportedLocales =>
      AppLanguage.values.map((l) => l.locale).toList();
}
