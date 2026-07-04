import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_route_observer.dart';
import '../../../core/routing/route_names.dart';
import '../../../shared/widgets/amount_text.dart';
import '../../../shared/widgets/empty_state.dart';
import '../domain/bill_repository.dart';
import 'bills_list_view_model.dart';
import 'widgets/bill_type_visuals.dart';

/// Home screen: the list of saved bills with a FAB to create a new one.
class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BillsListViewModel(getIt<BillRepository>())..load(),
      child: const _BillsView(),
    );
  }
}

class _BillsView extends StatefulWidget {
  const _BillsView();

  @override
  State<_BillsView> createState() => _BillsViewState();
}

class _BillsViewState extends State<_BillsView> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  /// Called when a route pushed on top of the bills list is popped — refresh so
  /// bills created or edited during that flow are reflected.
  @override
  void didPopNext() {
    context.read<BillsListViewModel>().load();
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).pushNamed(RouteNames.createBill);
  }

  void _openDetail(BuildContext context, int billId) {
    Navigator.of(context)
        .pushNamed(RouteNames.billDetail, arguments: billId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<BillsListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.billsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteNames.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreate(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.billsNewBill),
      ),
      body: viewModel.loading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.isEmpty
              ? EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.billsEmptyTitle,
                  message: l10n.billsEmptyBody,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: viewModel.bills.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final bill = viewModel.bills[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(bill.type.icon),
                        ),
                        title: Text(bill.title),
                        subtitle: Text(bill.type.label(l10n)),
                        trailing: AmountText(
                          bill.totalAmount,
                          currencyCode: bill.currencyCode,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        onTap: () => _openDetail(context, bill.id!),
                      ),
                    );
                  },
                ),
    );
  }
}
