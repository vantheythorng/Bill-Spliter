import 'package:intl/intl.dart';

/// Symbol overrides for currencies whose `intl` symbol differs from the
/// preferred display symbol (e.g. KHR uses "Riel" by default, we want "៛").
const Map<String, String> _kSymbolOverrides = {
  'KHR': '៛',
};

/// Formats monetary amounts using the app's selected currency. A single
/// instance is created per currency selection and shared via the settings
/// provider so formatting stays consistent app-wide.
class CurrencyFormatter {
  CurrencyFormatter(this.currencyCode)
      : _format = _kSymbolOverrides.containsKey(currencyCode)
            ? NumberFormat.currency(
                name: currencyCode,
                symbol: _kSymbolOverrides[currencyCode],
              )
            : NumberFormat.simpleCurrency(name: currencyCode);

  final String currencyCode;
  final NumberFormat _format;

  String format(double amount) => _format.format(amount);

  /// The currency symbol (e.g. `$`, `€`) for the current currency.
  String get symbol => _format.currencySymbol;
}
