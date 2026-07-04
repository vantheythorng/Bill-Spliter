/// Arguments passed to the equal/itemized/party editor routes.
///
/// [isNew] distinguishes the two entry points so the editor can navigate
/// correctly after saving:
/// - from the create flow ([isNew] true) it advances to the bill detail;
/// - from the detail screen's edit action ([isNew] false) it simply pops back
///   to the existing detail, which then refreshes.
class BillEditorArgs {
  const BillEditorArgs({required this.billId, this.isNew = false});

  final int billId;
  final bool isNew;
}
