import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../shared/models/bill_type.dart';

/// Maps a [BillType] to its icon, localized label and description. Keeps this
/// presentation detail in one place so every screen shows types consistently.
extension BillTypeVisuals on BillType {
  IconData get icon {
    switch (this) {
      case BillType.equal:
        return Icons.calculate_outlined;
      case BillType.itemized:
        return Icons.receipt_long_outlined;
      case BillType.party:
        return Icons.celebration_outlined;
    }
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case BillType.equal:
        return l10n.billTypeEqual;
      case BillType.itemized:
        return l10n.billTypeItemized;
      case BillType.party:
        return l10n.billTypeParty;
    }
  }

  String description(AppLocalizations l10n) {
    switch (this) {
      case BillType.equal:
        return l10n.billTypeEqualDescription;
      case BillType.itemized:
        return l10n.billTypeItemizedDescription;
      case BillType.party:
        return l10n.billTypePartyDescription;
    }
  }
}
