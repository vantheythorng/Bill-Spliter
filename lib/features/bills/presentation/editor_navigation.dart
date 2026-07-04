import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_names.dart';
import 'bill_editor_view_model.dart';

/// Saves the current bill draft and navigates away correctly for the editor's
/// entry point. Shared by the equal, itemized and party editors so their stack
/// handling stays consistent.
///
/// - Create flow ([isNew] true): replaces the editor with the bill detail, so
///   the stack is `[bills, detail]` and Back returns to the list.
/// - Edit flow ([isNew] false): pops back to the existing detail (which
///   refreshes), avoiding a second detail route stacking up.
Future<void> saveAndLeaveEditor(
  BuildContext context, {
  required bool isNew,
}) async {
  final viewModel = context.read<BillEditorViewModel>();
  final billId = viewModel.detail!.bill.id!;
  await viewModel.save();
  if (!context.mounted) return;
  if (isNew) {
    Navigator.of(context)
        .pushReplacementNamed(RouteNames.billDetail, arguments: billId);
  } else {
    Navigator.of(context).pop();
  }
}
