import 'package:intl/intl.dart';

/// Formats monetary amounts using the app's selected currency. A single
/// instance is created per currency selection and shared via the settings
/// provider so formatting stays consistent app-wide.
class CurrencyFormatter {
  CurrencyFormatter(this.currencyCode)
      : _format = NumberFormat.simpleCurrency(name: currencyCode);

  final String currencyCode;
  final NumberFormat _format;

  String format(double amount) => _format.format(amount);

  /// The currency symbol (e.g. `$`, `€`) for the current currency.
  String get symbol => _format.currencySymbol;
}
