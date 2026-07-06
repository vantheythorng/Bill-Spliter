import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../shared/models/bill_item.dart';
import '../../../../shared/models/person.dart';
import '../../../../shared/utils/validators.dart';
import '../../../../shared/widgets/app_text_field.dart';

/// Dialog to add or edit a line item and choose who shares it. Returns the
/// resulting [BillItem] (with assignments), or null if cancelled.
class ItemFormDialog extends StatefulWidget {
  const ItemFormDialog({
    super.key,
    required this.participants,
    this.initial,
  });

  final List<Person> participants;
  final BillItem? initial;

  static Future<BillItem?> show(
    BuildContext context, {
    required List<Person> participants,
    BillItem? initial,
  }) {
    return showDialog<BillItem>(
      context: context,
      builder: (_) =>
          ItemFormDialog(participants: participants, initial: initial),
    );
  }

  @override
  State<ItemFormDialog> createState() => _ItemFormDialogState();
}

class _ItemFormDialogState extends State<ItemFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name =
      TextEditingController(text: widget.initial?.name);
  late final TextEditingController _price = TextEditingController(
      text: widget.initial != null ? widget.initial!.price.toString() : '');
  late final TextEditingController _quantity = TextEditingController(
      text: (widget.initial?.quantity ?? 1).toString());
  late final Set<int> _assigned = {
    ...?widget.initial?.assignedPersonIds,
    // Default a brand-new item to everyone, matching the common case.
    if (widget.initial == null)
      ...widget.participants.map((p) => p.id!),
  };

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _quantity.dispose();
    super.dispose();
  }

  void _submit(AppLocalizations l10n) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_assigned.isEmpty) return;
    final item = (widget.initial ?? const BillItem(name: '', price: 0)).copyWith(
      name: _name.text.trim(),
      price: NumberParsing.tryParseAmount(_price.text) ?? 0,
      quantity: NumberParsing.tryParseInt(_quantity.text) ?? 1,
      assignedPersonIds: _assigned.toList(),
    );
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.initial == null ? l10n.addItem : l10n.edit),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _name,
                autofocus: true,
                label: l10n.itemNameLabel,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => Validators.required(v, l10n),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppTextField.amount(
                      controller: _price,
                      label: l10n.itemPriceLabel,
                      validator: (v) => Validators.positiveAmount(v, l10n),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppTextField(
                      controller: _quantity,
                      keyboardType: TextInputType.number,
                      label: l10n.itemQuantityLabel,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.assignedToLabel,
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final person in widget.participants)
                    FilterChip(
                      label: Text(person.name),
                      selected: _assigned.contains(person.id),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _assigned.add(person.id!);
                          } else {
                            _assigned.remove(person.id);
                          }
                        });
                      },
                    ),
                ],
              ),
            ],
          ),
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
