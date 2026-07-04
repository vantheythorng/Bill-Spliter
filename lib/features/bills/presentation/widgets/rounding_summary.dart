import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../shared/widgets/amount_text.dart';

/// Shows whether the rounding setting caused the collected shares to come out
/// with an **extra**, fall **short**, or add up exactly (**none**), based on a
/// settlement's [delta] (sum of shares − true total).
///
/// A small threshold guards against floating-point noise around zero.
class RoundingSummary extends StatelessWidget {
  const RoundingSummary({super.key, required this.delta, this.currencyCode});

  final double delta;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final IconData icon;
    final Color color;
    final String label;
    if (delta > 0.005) {
      icon = Icons.trending_up;
      color = theme.colorScheme.tertiary;
      label = l10n.roundingExtraLabel;
    } else if (delta < -0.005) {
      icon = Icons.trending_down;
      color = theme.colorScheme.error;
      label = l10n.roundingShortLabel;
    } else {
      icon = Icons.check_circle_outline;
      color = theme.colorScheme.primary;
      label = l10n.roundingExactLabel;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          if (delta.abs() > 0.005)
            AmountText(
              delta.abs(),
              currencyCode: currencyCode,
              color: color,
              style: theme.textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
