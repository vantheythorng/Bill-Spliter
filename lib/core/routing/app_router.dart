import 'package:flutter/material.dart';

import '../../features/bills/presentation/bill_detail_screen.dart';
import '../../features/bills/presentation/bill_editor_args.dart';
import '../../features/bills/presentation/bills_screen.dart';
import '../../features/bills/presentation/create_bill_screen.dart';
import '../../features/bills/presentation/equal_editor_screen.dart';
import '../../features/bills/presentation/itemized_editor_screen.dart';
import '../../features/bills/presentation/party_editor_screen.dart';
import '../../features/people/presentation/people_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import 'route_names.dart';

/// Central route generator. Routes that operate on a bill receive its id as the
/// route argument.
class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.bills:
        return _page(const BillsScreen(), settings);
      case RouteNames.createBill:
        return _page(const CreateBillScreen(), settings);
      case RouteNames.equalEditor:
        final args = settings.arguments as BillEditorArgs;
        return _page(
            EqualEditorScreen(billId: args.billId, isNew: args.isNew),
            settings);
      case RouteNames.itemizedEditor:
        final args = settings.arguments as BillEditorArgs;
        return _page(
            ItemizedEditorScreen(billId: args.billId, isNew: args.isNew),
            settings);
      case RouteNames.partyEditor:
        final args = settings.arguments as BillEditorArgs;
        return _page(
            PartyEditorScreen(billId: args.billId, isNew: args.isNew),
            settings);
      case RouteNames.billDetail:
        return _page(
            BillDetailScreen(billId: settings.arguments as int), settings);
      case RouteNames.people:
        return _page(const PeopleScreen(), settings);
      case RouteNames.settings:
        return _page(const SettingsScreen(), settings);
      default:
        return _page(const BillsScreen(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _page(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}
