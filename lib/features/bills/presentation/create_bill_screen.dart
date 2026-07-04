import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/route_names.dart';
import '../../../shared/models/bill_type.dart';
import '../../../shared/widgets/participant_picker.dart';
import '../../../shared/widgets/section_header.dart';
import '../../people/domain/person_repository.dart';
import '../../settings/domain/supported_currencies.dart';
import '../domain/bill_repository.dart';
import 'bill_editor_args.dart';
import 'create_bill_view_model.dart';
import 'widgets/bill_type_visuals.dart';

/// Step one of creating a bill: title, split type and participants.
class CreateBillScreen extends StatelessWidget {
  const CreateBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateBillViewModel(
        getIt<PersonRepository>(),
        getIt<BillRepository>(),
      )..load(),
      child: const _CreateBillView(),
    );
  }
}

class _CreateBillView extends StatelessWidget {
  const _CreateBillView();

  String _editorRoute(BillType type) {
    switch (type) {
      case BillType.equal:
        return RouteNames.equalEditor;
      case BillType.itemized:
        return RouteNames.itemizedEditor;
      case BillType.party:
        return RouteNames.partyEditor;
    }
  }

  Future<void> _proceed(BuildContext context) async {
    final viewModel = context.read<CreateBillViewModel>();
    final type = viewModel.type;
    final billId = await viewModel.createDraft();
    if (!context.mounted) return;
    // Replace this screen with the editor so Back returns to the bills list.
    Navigator.of(context).pushReplacementNamed(
      _editorRoute(type),
      arguments: BillEditorArgs(billId: billId, isNew: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<CreateBillViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createBillTitle)),
      body: viewModel.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.billTitleLabel,
                    hintText: l10n.billTitleHint,
                  ),
                  onChanged: viewModel.setTitle,
                ),
                const SizedBox(height: 16),
                SectionHeader(title: l10n.billTypeLabel),
                RadioGroup<BillType>(
                  groupValue: viewModel.type,
                  onChanged: (value) {
                    if (value != null) viewModel.setType(value);
                  },
                  child: Column(
                    children: [
                      for (final type in BillType.values)
                        Card(
                          child: RadioListTile<BillType>(
                            value: type,
                            secondary: Icon(type.icon),
                            title: Text(type.label(l10n)),
                            subtitle: Text(type.description(l10n)),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SectionHeader(title: l10n.settingsCurrency),
                _CurrencySelector(
                  selectedCode: viewModel.currencyCode,
                  onSelect: viewModel.setCurrency,
                ),
                const SizedBox(height: 8),
                SectionHeader(title: l10n.participantsLabel),
                ParticipantPicker(
                  people: viewModel.people,
                  selectedPersonIds: viewModel.selectedPersonIds,
                  onToggle: viewModel.toggleParticipant,
                  onQuickAdd: viewModel.quickAddPerson,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed:
                      viewModel.canProceed ? () => _proceed(context) : null,
                  child: Text(l10n.next),
                ),
              ],
            ),
    );
  }
}

/// Lets the user pick the currency this bill is recorded in.
class _CurrencySelector extends StatelessWidget {
  const _CurrencySelector({
    required this.selectedCode,
    required this.onSelect,
  });

  final String selectedCode;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.payments_outlined),
        title: Text(l10n.chooseCurrency),
        trailing: DropdownButton<String>(
          value: selectedCode,
          underline: const SizedBox.shrink(),
          // Show the compact code when collapsed; full label in the open menu.
          selectedItemBuilder: (context) => [
            for (final currency in kSupportedCurrencies)
              Align(
                alignment: Alignment.centerRight,
                child: Text(currency.code),
              ),
          ],
          onChanged: (code) {
            if (code != null) onSelect(code);
          },
          items: [
            for (final currency in kSupportedCurrencies)
              DropdownMenuItem(
                value: currency.code,
                child: Text('${currency.code} · ${currency.label}'),
              ),
          ],
        ),
      ),
    );
  }
}
