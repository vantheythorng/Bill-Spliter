import '../../../shared/models/bill.dart';
import '../../../shared/models/bill_detail.dart';
import '../domain/bill_repository.dart';
import 'bill_dao.dart';

class BillRepositoryImpl implements BillRepository {
  BillRepositoryImpl(this._dao);

  final BillDao _dao;

  @override
  Future<List<Bill>> getBills() => _dao.getBills();

  @override
  Future<BillDetail?> getBillDetail(int billId) => _dao.getDetail(billId);

  @override
  Future<int> save(BillDetail detail) => _dao.save(detail);

  @override
  Future<void> delete(int billId) => _dao.delete(billId);
}
