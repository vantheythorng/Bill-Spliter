import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/currency_formatter.dart';

/// Displays a monetary amount. By default it uses the app-wide
/// [CurrencyFormatter] provided above this widget (and rebuilds when the default
/// currency changes). Pass [currencyCode] to format a specific currency — used
/// for bills recorded in a manually chosen currency. A `null` [currencyCode]
/// falls back to the app default, which is exactly what "system currency" bills
/// want.
class AmountText extends StatelessWidget {
  const AmountText(
    this.amount, {
    super.key,
    this.currencyCode,
    this.style,
    this.color,
  });

  final double amount;
  final String? currencyCode;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final code = currencyCode;
    final formatter =
        code != null ? CurrencyFormatter(code) : context.watch<CurrencyFormatter>();
    return Text(
      formatter.format(amount),
      style: (style ?? const TextStyle()).copyWith(color: color),
    );
  }
}
