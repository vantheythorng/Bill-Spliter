import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/route_names.dart';
import '../../../shared/models/bill_type.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/amount_text.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/person_avatar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../settings/presentation/settings_provider.dart';
import '../domain/bill_repository.dart';
import '../domain/services/split_service.dart';
import 'bill_detail_view_model.dart';
import 'bill_editor_args.dart';
import 'widgets/bill_type_visuals.dart';
import 'widgets/rounding_summary.dart';

/// Read-only bill summary: per-person breakdown and settle-up transactions.
class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({super.key, required this.billId});

  final int billId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BillDetailViewModel(
        getIt<BillRepository>(),
        getIt<SplitService>(),
      )..load(billId),
      child: _BillDetailView(billId: billId),
    );
  }
}

class _BillDetailView extends StatelessWidget {
  const _BillDetailView({required this.billId});

  final int billId;

  /// Formatter for the bill's own currency, falling back to the app default
  /// (which is what "system currency" bills use).
  CurrencyFormatter _formatFor(BuildContext context, String? currencyCode) {
    return currencyCode != null
        ? CurrencyFormatter(currencyCode)
        : context.watch<CurrencyFormatter>();
  }

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

  Future<void> _edit(BuildContext context, BillType type) async {
    await Navigator.of(context).pushNamed(
      _editorRoute(type),
      arguments: BillEditorArgs(billId: billId, isNew: false),
    );
    if (context.mounted) {
      await context.read<BillDetailViewModel>().load(billId);
    }
  }

  Future<void> _delete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.deleteBillTitle,
      message: l10n.deleteBillBody,
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    await context.read<BillDetailViewModel>().delete();
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final viewModel = context.watch<BillDetailViewModel>();
    viewModel.rounding = context.watch<SettingsProvider>().roundingMode;
    final detail = viewModel.detail;

    if (viewModel.loading || detail == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.billDetailTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final bill = detail.bill;
    final currency = bill.currencyCode;
    final settlement = viewModel.settlement;
    final showSettleUp = bill.type != BillType.equal;

    return Scaffold(
      appBar: AppBar(
        title: Text(bill.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _edit(context, bill.type),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(child: Icon(bill.type.icon)),
                  title: Text(bill.type.label(l10n)),
                  trailing: AmountText(
                    bill.totalAmount,
                    currencyCode: currency,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: RoundingSummary(
                    delta: settlement.roundingDelta,
                    currencyCode: currency,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader(title: l10n.breakdownLabel),
          for (final share in settlement.shares)
            Builder(builder: (context) {
              final person = detail.personById(share.personId);
              return Card(
                child: ListTile(
                  leading: person == null
                      ? const CircleAvatar(child: Icon(Icons.person))
                      : PersonAvatar(person: person),
                  title: Text(person?.name ?? '—'),
                  subtitle: showSettleUp
                      ? Text('${l10n.paidAmountLabel}: '
                          '${_formatFor(context, currency).format(share.paid)}')
                      : null,
                  trailing: AmountText(
                    share.owed,
                    currencyCode: currency,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              );
            }),
          if (showSettleUp) ...[
            const SizedBox(height: 8),
            SectionHeader(title: l10n.settleUpLabel),
            if (settlement.transfers.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(child: Text(l10n.allSettled)),
                    ],
                  ),
                ),
              )
            else
              for (final transfer in settlement.transfers)
                Builder(builder: (context) {
                  final from = detail.personById(transfer.fromPersonId);
                  final to = detail.personById(transfer.toPersonId);
                  return Card(
                    child: ListTile(
                      leading: from == null
                          ? const CircleAvatar(child: Icon(Icons.person))
                          : PersonAvatar(person: from, radius: 16),
                      title: Text(l10n.paysTo(
                        from?.name ?? '—',
                        to?.name ?? '—',
                      )),
                      trailing: AmountText(
                        transfer.amount,
                        currencyCode: currency,
                        style: theme.textTheme.titleMedium,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  );
                }),
          ],
        ],
      ),
    );
  }
}
