/// A small curated list of currencies offered in the settings picker. This is
/// display metadata only — formatting is handled by `intl`.
class SupportedCurrency {
  const SupportedCurrency(this.code, this.label);
  final String code;
  final String label;
}

const List<SupportedCurrency> kSupportedCurrencies = [
  SupportedCurrency('USD', 'US Dollar'),
  SupportedCurrency('KHR', 'Khmer Riel'),
  SupportedCurrency('CNY', 'Chinese Yuan'),
];

const String kDefaultCurrencyCode = 'USD';
