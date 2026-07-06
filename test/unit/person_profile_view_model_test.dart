import 'package:bill_splitter/core/repository/bills/bill_repository.dart';
import 'package:bill_splitter/features/people/presentation/person_profile_view_model.dart';
import 'package:bill_splitter/shared/models/bill.dart';
import 'package:bill_splitter/shared/models/bill_detail.dart';
import 'package:bill_splitter/shared/models/bill_type.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records the person id requested and returns a canned list of bills.
class _FakeBillRepository implements BillRepository {
  _FakeBillRepository(this._byPerson);

  final Map<int, List<Bill>> _byPerson;
  int? lastRequestedPersonId;

  @override
  Future<List<Bill>> getBillsForPerson(int personId) async {
    lastRequestedPersonId = personId;
    return _byPerson[personId] ?? const [];
  }

  @override
  Future<List<Bill>> getBills() async => const [];

  @override
  Future<BillDetail?> getBillDetail(int billId) async => null;

  @override
  Future<int> save(BillDetail detail) async => 1;

  @override
  Future<void> delete(int billId) async {}
}

void main() {
  test('loads the bill history for the requested person', () async {
    final repo = _FakeBillRepository({
      7: const [
        Bill(id: 1, title: 'Dinner', type: BillType.equal),
        Bill(id: 2, title: 'Trip', type: BillType.party),
      ],
    });
    final vm = PersonProfileViewModel(repo);

    await vm.load(7);

    expect(repo.lastRequestedPersonId, 7);
    expect(vm.bills.map((b) => b.title), ['Dinner', 'Trip']);
    expect(vm.isEmpty, isFalse);
    expect(vm.loading, isFalse);
  });

  test('reports empty when the person is in no bills', () async {
    final vm = PersonProfileViewModel(_FakeBillRepository(const {}));

    await vm.load(99);

    expect(vm.bills, isEmpty);
    expect(vm.isEmpty, isTrue);
  });
}
