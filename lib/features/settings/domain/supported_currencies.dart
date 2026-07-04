/// A small curated list of currencies offered in the settings picker. This is
/// display metadata only — formatting is handled by `intl`.
class SupportedCurrency {
  const SupportedCurrency(this.code, this.label);
  final String code;
  final String label;
}

const List<SupportedCurrency> kSupportedCurrencies = [
  SupportedCurrency('USD', 'US Dollar'),
  SupportedCurrency('EUR', 'Euro'),
  SupportedCurrency('GBP', 'British Pound'),
  SupportedCurrency('JPY', 'Japanese Yen'),
  SupportedCurrency('THB', 'Thai Baht'),
  SupportedCurrency('SGD', 'Singapore Dollar'),
  SupportedCurrency('AUD', 'Australian Dollar'),
  SupportedCurrency('CAD', 'Canadian Dollar'),
  SupportedCurrency('INR', 'Indian Rupee'),
  SupportedCurrency('CNY', 'Chinese Yuan'),
];

const String kDefaultCurrencyCode = 'USD';
