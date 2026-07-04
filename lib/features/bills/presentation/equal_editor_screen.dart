import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/amount_text.dart';
import '../../../shared/widgets/person_avatar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/participant_picker.dart';
import '../../people/domain/person_repository.dart';
import '../../settings/presentation/settings_provider.dart';
import '../domain/bill_repository.dart';
import '../domain/services/split_service.dart';
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
                TextFormField(
                  initialValue: detail.bill.title,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: l10n.billTitleLabel),
                  onChanged: viewModel.setTitle,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: detail.bill.totalAmount > 0
                      ? detail.bill.totalAmount.toString()
                      : '',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.totalAmountLabel),
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
                  Builder(builder: (context) {
                    final person = viewModel.personById(share.personId);
                    return Card(
                      child: ListTile(
                        leading: person == null
                            ? const CircleAvatar(child: Icon(Icons.person))
                            : PersonAvatar(person: person),
                        title: Text(person?.name ?? '—'),
                        trailing: AmountText(
                          share.owed,
                          currencyCode: detail.bill.currencyCode,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    );
                  }),
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
