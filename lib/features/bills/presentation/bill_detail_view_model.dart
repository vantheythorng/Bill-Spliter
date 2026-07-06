import 'package:flutter/foundation.dart';

import '../../../shared/models/bill_detail.dart';
import '../../../shared/models/settlement.dart';
import '../../../shared/utils/rounding_mode.dart';
import '../../../core/repository/bills/bill_repository.dart';
import '../../../core/services/bills/split_service.dart';

/// View model for the read-only bill summary: loads the aggregate and computes
/// the settlement for display.
class BillDetailViewModel extends ChangeNotifier {
  BillDetailViewModel(this._repository, this._splitService);

  final BillRepository _repository;
  final SplitService _splitService;

  BillDetail? _detail;
  bool _loading = false;
  RoundingMode _rounding = RoundingMode.defaultMode;

  BillDetail? get detail => _detail;
  bool get loading => _loading;

  /// The current split result, recomputed with the active rounding mode.
  Settlement get settlement => _detail == null
      ? const Settlement(shares: [])
      : _splitService.split(_detail!, rounding: _rounding);

  /// Set from the current settings by the screen (plain setter — safe to call
  /// during build).
  set rounding(RoundingMode mode) => _rounding = mode;

  Future<void> load(int billId) async {
    _loading = true;
    notifyListeners();
    _detail = await _repository.getBillDetail(billId);
    _loading = false;
    notifyListeners();
  }

  Future<void> delete() async {
    final id = _detail?.bill.id;
    if (id != null) await _repository.delete(id);
  }
}
