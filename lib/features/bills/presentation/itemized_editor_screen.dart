import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../shared/models/bill_item.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/amount_text.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/participant_picker.dart';
import '../../../shared/widgets/person_avatar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../core/repository/people/person_repository.dart';
import '../../../core/repository/bills/bill_repository.dart';
import '../../../core/services/bills/split_service.dart';
import 'bill_editor_view_model.dart';
import 'editor_navigation.dart';
import 'widgets/item_form_dialog.dart';

/// Itemized editor: add line items, assign them to people, record who paid.
class ItemizedEditorScreen extends StatelessWidget {
  const ItemizedEditorScreen({
    super.key,
    required this.billId,
    this.isNew = false,
  });

  final int billId;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BillEditorViewModel(
        getIt<BillRepository>(),
        getIt<SplitService>(),
        getIt<PersonRepository>(),
      )..load(billId),
      child: _ItemizedEditorView(isNew: isNew),
    );
  }
}

class _ItemizedEditorView extends StatelessWidget {
  const _ItemizedEditorView({required this.isNew});

  final bool isNew;

  Future<void> _addItem(BuildContext context) async {
    final viewModel = context.read<BillEditorViewModel>();
    final item = await ItemFormDialog.show(
      context,
      participants: viewModel.participants,
    );
    if (item != null) viewModel.addItem(item);
  }

  Future<void> _editItem(BuildContext context, int index, BillItem item) async {
    final viewModel = context.read<BillEditorViewModel>();
    final edited = await ItemFormDialog.show(
      context,
      participants: viewModel.participants,
      initial: item,
    );
    if (edited != null) viewModel.updateItem(index, edited);
  }

  Future<void> _save(BuildContext context) =>
      saveAndLeaveEditor(context, isNew: isNew);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<BillEditorViewModel>();
    final detail = viewModel.detail;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.itemizedEditorTitle)),
      floatingActionButton: detail == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _addItem(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.addItem),
            ),
      body: viewModel.loading || detail == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                SectionHeader(title: l10n.billTitleLabel),
                AppTextField(
                  hint: l10n.billTitleLabel,
                  initialValue: detail.bill.title,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: viewModel.setTitle,
                ),
                const SizedBox(height: 16),
                SectionHeader(title: l10n.participantsLabel),
                ParticipantPicker(
                  people: viewModel.allPeople,
                  selectedPersonIds: viewModel.selectedPersonIds,
                  onToggle: viewModel.toggleParticipant,
                  onQuickAdd: viewModel.quickAddPerson,
                ),
                const SizedBox(height: 16),
                SectionHeader(title: l10n.itemizedEditorTitle),
                if (viewModel.items.isEmpty)
                  EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: l10n.noItemsYet,
                    message: l10n.addItem,
                  )
                else
                  for (var i = 0; i < viewModel.items.length; i++)
                    _ItemTile(
                      item: viewModel.items[i],
                      subtitle: _assignedNames(viewModel, viewModel.items[i]),
                      currencyCode: detail.bill.currencyCode,
                      onEdit: () => _editItem(context, i, viewModel.items[i]),
                      onDelete: () => viewModel.removeItem(i),
                    ),
                const SizedBox(height: 16),
                SectionHeader(title: l10n.deliveryFeeLabel),
                AppTextField.amount(
                  hint: l10n.deliveryFeeLabel,
                  initialValue: detail.bill.deliveryFee > 0
                      ? detail.bill.deliveryFee.toString()
                      : '',
                  onChanged: (value) => viewModel.setDeliveryFee(
                    NumberParsing.tryParseAmount(value) ?? 0,
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(title: l10n.paymentsLabel),
                for (final person in viewModel.participants)
                  _PaidField(
                    key: ValueKey('paid_${person.id}'),
                    label: person.name,
                    leading: PersonAvatar(person: person, radius: 16),
                    initialValue: viewModel.paidAmountFor(person.id!),
                    onChanged: (value) =>
                        viewModel.setPaidAmount(person.id!, value),
                  ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: viewModel.saving ? null : () => _save(context),
                  child: Text(l10n.save),
                ),
              ],
            ),
    );
  }

  String _assignedNames(BillEditorViewModel viewModel, BillItem item) {
    final names = item.assignedPersonIds
        .map((id) => viewModel.personById(id)?.name)
        .whereType<String>()
        .join(', ');
    return names;
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.subtitle,
    required this.currencyCode,
    required this.onEdit,
    required this.onDelete,
  });

  final BillItem item;
  final String subtitle;
  final String? currencyCode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final qtyPrefix = item.quantity > 1 ? '${item.quantity}× ' : '';
    final hasFee = item.packagingFee > 0;
    return Card(
      child: ListTile(
        title: Text('$qtyPrefix${item.name}'),
        subtitle: subtitle.isEmpty && !hasFee
            ? null
            : Row(
                children: [
                  if (subtitle.isNotEmpty)
                    Flexible(
                      child: Text(subtitle, overflow: TextOverflow.ellipsis),
                    ),
                  if (hasFee) ...[
                    if (subtitle.isNotEmpty) const SizedBox(width: 8),
                    Text(
                      '${l10n.packagingFeeLabel} ',
                      style: theme.textTheme.bodySmall,
                    ),
                    AmountText(
                      item.packagingFee,
                      currencyCode: currencyCode,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
        onTap: onEdit,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AmountText(item.lineTotalWithFee, currencyCode: currencyCode),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// A stable text field for entering how much a person paid.
class _PaidField extends StatefulWidget {
  const _PaidField({
    super.key,
    required this.label,
    required this.leading,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final Widget leading;
  final double initialValue;
  final ValueChanged<double> onChanged;

  @override
  State<_PaidField> createState() => _PaidFieldState();
}

class _PaidFieldState extends State<_PaidField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue > 0 ? widget.initialValue.toString() : '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          widget.leading,
          const SizedBox(width: 12),
          Expanded(child: Text(widget.label)),
          SizedBox(
            width: 120,
            child: AppTextField.amount(
              controller: _controller,
              textAlign: TextAlign.end,
              isDense: true,
              hint: l10n.paidAmountLabel,
              onChanged: (value) =>
                  widget.onChanged(NumberParsing.tryParseAmount(value) ?? 0),
            ),
          ),
        ],
      ),
    );
  }
}
