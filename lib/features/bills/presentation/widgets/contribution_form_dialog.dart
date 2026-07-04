import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../shared/models/party_contribution.dart';
import '../../../../shared/models/person.dart';
import '../../../../shared/utils/validators.dart';

/// Dialog to add a party contribution: who paid, how much, and an optional
/// label. Returns the [PartyContribution] or null if cancelled.
class ContributionFormDialog extends StatefulWidget {
  const ContributionFormDialog({super.key, required this.participants});

  final List<Person> participants;

  static Future<PartyContribution?> show(
    BuildContext context, {
    required List<Person> participants,
  }) {
    return showDialog<PartyContribution>(
      context: context,
      builder: (_) => ContributionFormDialog(participants: participants),
    );
  }

  @override
  State<ContributionFormDialog> createState() => _ContributionFormDialogState();
}

class _ContributionFormDialogState extends State<ContributionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _label = TextEditingController();
  late int? _payerId = widget.participants.firstOrNull?.id;

  @override
  void dispose() {
    _amount.dispose();
    _label.dispose();
    super.dispose();
  }

  void _submit(AppLocalizations l10n) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_payerId == null) return;
    Navigator.of(context).pop(PartyContribution(
      personId: _payerId!,
      amount: NumberParsing.tryParseAmount(_amount.text) ?? 0,
      label: _label.text.trim().isEmpty ? null : _label.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.addContribution),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              initialValue: _payerId,
              decoration:
                  InputDecoration(labelText: l10n.contributionPayerLabel),
              items: [
                for (final person in widget.participants)
                  DropdownMenuItem(value: person.id, child: Text(person.name)),
              ],
              onChanged: (value) => setState(() => _payerId = value),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amount,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration:
                  InputDecoration(labelText: l10n.contributionAmountLabel),
              validator: (v) => Validators.positiveAmount(v, l10n),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _label,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  InputDecoration(labelText: l10n.contributionLabelHint),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: () => _submit(l10n), child: Text(l10n.save)),
      ],
    );
  }
}
