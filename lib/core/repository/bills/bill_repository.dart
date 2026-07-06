import '../../../shared/models/bill.dart';
import '../../../shared/models/bill_detail.dart';

/// Abstract contract for persisting bills and their child data.
abstract class BillRepository {
  /// All bills, most-recently-updated first (for the home list).
  Future<List<Bill>> getBills();

  /// Every bill the given person appears in, most-recently-updated first.
  Future<List<Bill>> getBillsForPerson(int personId);

  /// The fully-loaded aggregate for a single bill, or null if it was deleted.
  Future<BillDetail?> getBillDetail(int billId);

  /// Creates or updates the whole aggregate atomically; returns the bill id.
  Future<int> save(BillDetail detail);

  Future<void> delete(int billId);
}
