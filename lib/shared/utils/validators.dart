import '../../core/localization/generated/app_localizations.dart';

/// Reusable form-field validators. They take the [AppLocalizations] instance so
/// error text is localized at the call site.
class Validators {
  const Validators._();

  static String? required(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationRequired;
    }
    return null;
  }

  /// Validates that [value] parses to a number greater than zero.
  static String? positiveAmount(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationRequired;
    }
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) {
      return l10n.validationInvalidNumber;
    }
    if (parsed <= 0) {
      return l10n.validationPositive;
    }
    return null;
  }
}

/// Parsing helpers that tolerate comma decimal separators.
class NumberParsing {
  const NumberParsing._();

  static double? tryParseAmount(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));

  static int? tryParseInt(String value) => int.tryParse(value.trim());
}
