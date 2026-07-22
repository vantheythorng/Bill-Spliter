import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../shared/widgets/amount_text.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/participant_picker.dart';
import '../../../shared/widgets/person_amount_tile.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../core/repository/people/person_repository.dart';
import '../../settings/presentation/settings_provider.dart';
import '../../../core/repository/bills/bill_repository.dart';
import '../../../core/services/bills/split_service.dart';
import 'bill_editor_view_model.dart';
import 'editor_navigation.dart';
import 'widgets/contribution_form_dialog.dart';

/// Party editor: log contributions (who paid, amount, optional label) and see
/// the grand total, equal share and each person's balance live.
class PartyEditorScreen extends StatelessWidget {
  const PartyEditorScreen({
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
      child: _PartyEditorView(isNew: isNew),
    );
  }
}

class _PartyEditorView extends StatelessWidget {
  const _PartyEditorView({required this.isNew});

  final bool isNew;

  Future<void> _addContribution(BuildContext context) async {
    final viewModel = context.read<BillEditorViewModel>();
    final contribution = await ContributionFormDialog.show(
      context,
      participants: viewModel.participants,
    );
    if (contribution != null) viewModel.addContribution(contribution);
  }

  Future<void> _save(BuildContext context) =>
      saveAndLeaveEditor(context, isNew: isNew);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final viewModel = context.watch<BillEditorViewModel>();
    viewModel.rounding = context.watch<SettingsProvider>().roundingMode;
    final detail = viewModel.detail;

    if (viewModel.loading || detail == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.partyEditorTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final preview = viewModel.preview;
    final currency = detail.bill.currencyCode;
    final grandTotal = detail.contributions
        .fold<double>(0, (sum, c) => sum + c.amount);
    // The nominal even share per the spec (grandTotal / people). The per-person
    // breakdown below still uses the exact largest-remainder shares, so the one
    // cent of rounding is absorbed there rather than shown in this summary.
    final peopleCount = detail.participantPersonIds.length;
    final equalShare = peopleCount == 0 ? 0.0 : grandTotal / peopleCount;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.partyEditorTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addContribution(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addContribution),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          SectionHeader(title: l10n.billTitleLabel),
          AppTextField(
            hint: l10n.billTitleHint,
            initialValue: detail.bill.title,
            textCapitalization: TextCapitalization.sentences,
            onChanged: viewModel.setTitle,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.grandTotal, style: theme.textTheme.labelMedium),
                      AmountText(grandTotal,
                          currencyCode: currency,
                          style: theme.textTheme.headlineSmall),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(l10n.equalShare, style: theme.textTheme.labelMedium),
                      AmountText(equalShare,
                          currencyCode: currency,
                          style: theme.textTheme.titleLarge),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader(title: l10n.participantsLabel),
          ParticipantPicker(
            people: viewModel.allPeople,
            selectedPersonIds: viewModel.selectedPersonIds,
            onToggle: viewModel.toggleParticipant,
            onQuickAdd: viewModel.quickAddPerson,
          ),
          const SizedBox(height: 8),
          SectionHeader(title: l10n.partyEditorTitle),
          if (detail.contributions.isEmpty)
            EmptyState(
              icon: Icons.celebration_outlined,
              title: l10n.noContributionsYet,
              message: l10n.addContribution,
            )
          else
            for (var i = 0; i < detail.contributions.length; i++)
              PersonAmountTile(
                person: viewModel.personById(detail.contributions[i].personId),
                amount: detail.contributions[i].amount,
                currencyCode: currency,
                subtitle: detail.contributions[i].label,
                avatarRadius: 16,
                onDelete: () => viewModel.removeContribution(i),
              ),
          const SizedBox(height: 8),
          SectionHeader(title: l10n.breakdownLabel),
          for (final share in preview.shares)
            PersonAmountTile(
              person: viewModel.personById(share.personId),
              amount: share.balance.abs(),
              currencyCode: currency,
              subtitle: share.balance >= 0
                  ? l10n.getsBackLabel
                  : l10n.owesLabel,
              amountColor: share.balance >= 0
                  ? Colors.green
                  : theme.colorScheme.error,
              amountStyle: theme.textTheme.titleMedium,
              avatarRadius: 16,
              card: false,
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: viewModel.saving ? null : () => _save(context),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
