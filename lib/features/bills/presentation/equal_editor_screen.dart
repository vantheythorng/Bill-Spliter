import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/participant_picker.dart';
import '../../../shared/widgets/person_amount_tile.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../core/repository/people/person_repository.dart';
import '../../settings/presentation/settings_provider.dart';
import '../../../core/repository/bills/bill_repository.dart';
import '../../../core/services/bills/split_service.dart';
import 'bill_editor_view_model.dart';
import 'editor_navigation.dart';
import 'widgets/rounding_summary.dart';

/// Equal split editor: enter a total, see each person's share live.
class EqualEditorScreen extends StatelessWidget {
  const EqualEditorScreen({
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
      child: _EqualEditorView(isNew: isNew),
    );
  }
}

class _EqualEditorView extends StatelessWidget {
  const _EqualEditorView({required this.isNew});

  final bool isNew;

  Future<void> _save(BuildContext context) =>
      saveAndLeaveEditor(context, isNew: isNew);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<BillEditorViewModel>();
    viewModel.rounding = context.watch<SettingsProvider>().roundingMode;
    final detail = viewModel.detail;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.equalEditorTitle)),
      body: viewModel.loading || detail == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppTextField(
                  label: l10n.billTitleLabel,
                  initialValue: detail.bill.title,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: viewModel.setTitle,
                ),
                const SizedBox(height: 16),
                AppTextField.amount(
                  label: l10n.totalAmountLabel,
                  initialValue: detail.bill.totalAmount > 0
                      ? detail.bill.totalAmount.toString()
                      : '',
                  onChanged: (value) => viewModel
                      .setTotal(NumberParsing.tryParseAmount(value) ?? 0),
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
                SectionHeader(title: l10n.perPersonShare),
                for (final share in viewModel.preview.shares)
                  PersonAmountTile(
                    person: viewModel.personById(share.personId),
                    amount: share.owed,
                    currencyCode: detail.bill.currencyCode,
                    amountStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                if (viewModel.preview.shares.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: RoundingSummary(
                      delta: viewModel.preview.roundingDelta,
                      currencyCode: detail.bill.currencyCode,
                    ),
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
}
