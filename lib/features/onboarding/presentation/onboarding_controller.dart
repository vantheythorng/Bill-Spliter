import 'package:flutter/foundation.dart';

import '../../../core/preferences/app_preferences.dart';

/// Holds whether onboarding has been completed and persists the flag. Provided
/// at the app root so [App] can decide between the onboarding storyboard and
/// the home screen, and rebuild when onboarding finishes.
class OnboardingController extends ChangeNotifier {
  OnboardingController(this._prefs)
      : _completed = _prefs.hasCompletedOnboarding;

  final AppPreferences _prefs;

  bool _completed;
  bool get hasCompletedOnboarding => _completed;

  Future<void> complete() async {
    if (_completed) return;
    _completed = true;
    notifyListeners();
    await _prefs.setOnboardingCompleted();
  }
}
