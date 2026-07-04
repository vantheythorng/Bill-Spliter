import 'package:flutter/foundation.dart';

import '../../../shared/models/bill.dart';
import '../domain/bill_repository.dart';

/// View model for the home Bills list.
class BillsListViewModel extends ChangeNotifier {
  BillsListViewModel(this._repository);

  final BillRepository _repository;

  List<Bill> _bills = [];
  bool _loading = false;

  List<Bill> get bills => List.unmodifiable(_bills);
  bool get loading => _loading;
  bool get isEmpty => !_loading && _bills.isEmpty;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _bills = await _repository.getBills();
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteBill(int billId) async {
    await _repository.delete(billId);
    await load();
  }
}
