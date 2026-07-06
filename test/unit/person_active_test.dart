import 'package:bill_splitter/features/bills/domain/bill_repository.dart';
import 'package:bill_splitter/features/bills/domain/services/split_service.dart';
import 'package:bill_splitter/features/bills/presentation/bill_editor_view_model.dart';
import 'package:bill_splitter/features/bills/presentation/create_bill_view_model.dart';
import 'package:bill_splitter/features/people/domain/person_repository.dart';
import 'package:bill_splitter/shared/models/bill.dart';
import 'package:bill_splitter/shared/models/bill_detail.dart';
import 'package:bill_splitter/shared/models/bill_participant.dart';
import 'package:bill_splitter/shared/models/bill_type.dart';
import 'package:bill_splitter/shared/models/person.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory people store used to drive the view models without SQLite.
class _FakePersonRepository implements PersonRepository {
  _FakePersonRepository(this._people);

  final List<Person> _people;
  final Set<int> referenced = {};

  @override
  Future<List<Person>> getAll() async => List.of(_people);

  @override
  Future<Person> add(String name) async {
    final person = Person(id: _people.length + 1, name: name.trim(), colorSeed: 0);
    _people.add(person);
    return person;
  }

  @override
  Future<void> update(Person person) async {}

  @override
  Future<void> delete(int id) async => _people.removeWhere((p) => p.id == id);

  @override
  Future<void> setActive(int id, bool active) async {
    final i = _people.indexWhere((p) => p.id == id);
    if (i != -1) _people[i] = _people[i].copyWith(active: active);
  }

  @override
  Future<bool> isReferenced(int id) async => referenced.contains(id);

  @override
  Future<Set<int>> referencedIds() async => Set.of(referenced);
}

class _FakeBillRepository implements BillRepository {
  _FakeBillRepository(this._detail);

  final BillDetail _detail;

  @override
  Future<BillDetail?> getBillDetail(int billId) async => _detail;

  @override
  Future<List<Bill>> getBills() async => const [];

  @override
  Future<int> save(BillDetail detail) async => 1;

  @override
  Future<void> delete(int billId) async {}
}

void main() {
  test('Person active flag round-trips through toMap/fromMap (defaults true)', () {
    const active = Person(id: 1, name: 'Ada', colorSeed: 3);
    expect(active.active, isTrue);

    final inactive = active.copyWith(active: false);
    final restored = Person.fromMap(inactive.toMap());
    expect(restored.active, isFalse);

    // A row written before the column existed decodes as active.
    final legacy = Person.fromMap({'id': 2, 'name': 'Bob', 'color_seed': 0});
    expect(legacy.active, isTrue);
  });

  test('CreateBillViewModel hides deactivated people from selection', () async {
    final people = [
      const Person(id: 1, name: 'Ada', colorSeed: 0),
      const Person(id: 2, name: 'Bob', colorSeed: 0, active: false),
    ];
    final vm = CreateBillViewModel(
      _FakePersonRepository(people),
      _FakeBillRepository(const BillDetail(
        bill: Bill(title: 't', type: BillType.equal),
        participants: [],
        people: [],
      )),
    );
    await vm.load();

    expect(vm.people.map((p) => p.name), ['Ada']);
  });

  test(
      'BillEditorViewModel hides deactivated people but keeps an already-selected one',
      () async {
    final people = [
      const Person(id: 1, name: 'Ada', colorSeed: 0),
      const Person(id: 2, name: 'Bob', colorSeed: 0, active: false),
      const Person(id: 3, name: 'Cy', colorSeed: 0, active: false),
    ];
    // Bob (deactivated) is already a participant of this existing bill.
    final detail = BillDetail(
      bill: const Bill(id: 1, title: 'Dinner', type: BillType.equal),
      participants: const [BillParticipant(personId: 2)],
      people: const [Person(id: 2, name: 'Bob', colorSeed: 0, active: false)],
    );
    final vm = BillEditorViewModel(
      _FakeBillRepository(detail),
      const SplitService(),
      _FakePersonRepository(people),
    );
    await vm.load(1);

    final names = vm.allPeople.map((p) => p.name).toList();
    expect(names, containsAll(['Ada', 'Bob'])); // active + already-selected
    expect(names, isNot(contains('Cy'))); // deactivated & not selected
  });
}
