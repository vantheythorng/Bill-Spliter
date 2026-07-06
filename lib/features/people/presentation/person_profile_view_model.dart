import 'package:flutter/foundation.dart';

import '../../../shared/models/bill.dart';
import '../../../core/repository/bills/bill_repository.dart';

/// Loads the read-only bill history for a single person's profile screen.
class PersonProfileViewModel extends ChangeNotifier {
  PersonProfileViewModel(this._repository);

  final BillRepository _repository;

  List<Bill> _bills = [];
  bool _loading = false;

  List<Bill> get bills => List.unmodifiable(_bills);
  bool get loading => _loading;
  bool get isEmpty => !_loading && _bills.isEmpty;

  Future<void> load(int personId) async {
    _loading = true;
    notifyListeners();
    _bills = await _repository.getBillsForPerson(personId);
    _loading = false;
    notifyListeners();
  }
}
