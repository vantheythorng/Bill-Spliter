import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/route_names.dart';
import '../../../shared/models/person.dart';
import '../../../shared/widgets/amount_text.dart';
import '../../../shared/widgets/muted_text.dart';
import '../../../shared/widgets/person_avatar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../core/repository/bills/bill_repository.dart';
import '../../bills/presentation/widgets/bill_type_visuals.dart';
import 'person_profile_view_model.dart';

/// A person's profile: their identity plus the history of every bill they
/// appear in. Tapping a bill opens it in read-only detail.
class PersonProfileScreen extends StatelessWidget {
  const PersonProfileScreen({super.key, required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PersonProfileViewModel(getIt<BillRepository>())..load(person.id!),
      child: _PersonProfileView(person: person),
    );
  }
}

class _PersonProfileView extends StatelessWidget {
  const _PersonProfileView({required this.person});

  final Person person;

  void _openBill(BuildContext context, int billId) {
    Navigator.of(context)
        .pushNamed(RouteNames.billDetailReadOnly, arguments: billId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final viewModel = context.watch<PersonProfileViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(person.name)),
      body: viewModel.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Card(
                  child: ListTile(
                    leading: PersonAvatar(person: person, radius: 24),
                    title:
                        Text(person.name, style: theme.textTheme.titleLarge),
                    subtitle: person.active ? null : Text(l10n.inactive),
                  ),
                ),
                const SizedBox(height: 8),
                SectionHeader(title: l10n.billsTitle),
                if (viewModel.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: MutedText(
                      l10n.personNoBills,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  for (final bill in viewModel.bills)
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Icon(bill.type.icon)),
                        title: Text(bill.title),
                        subtitle: Text(bill.type.label(l10n)),
                        trailing: AmountText(
                          bill.totalAmount,
                          currencyCode: bill.currencyCode,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        onTap: () => _openBill(context, bill.id!),
                      ),
                    ),
              ],
            ),
    );
  }
}
