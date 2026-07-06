import 'package:flutter/foundation.dart';

import '../../../shared/models/bill_detail.dart';
import '../../../shared/models/bill_item.dart';
import '../../../shared/models/bill_participant.dart';
import '../../../shared/models/bill_type.dart';
import '../../../shared/models/party_contribution.dart';
import '../../../shared/models/person.dart';
import '../../../shared/models/settlement.dart';
import '../../../shared/utils/rounding_mode.dart';
import '../../people/domain/person_repository.dart';
import '../domain/bill_repository.dart';
import '../domain/services/split_service.dart';

/// Editor for an existing bill draft. Loads the [BillDetail], applies
/// type-specific edits, exposes a live [Settlement] preview, and persists on
/// save. Shared by the equal, itemized and party editors.
class BillEditorViewModel extends ChangeNotifier {
  BillEditorViewModel(
    this._repository,
    this._splitService,
    this._personRepository,
  );

  final BillRepository _repository;
  final SplitService _splitService;
  final PersonRepository _personRepository;

  BillDetail? _detail;
  List<Person> _allPeople = [];
  bool _loading = false;
  bool _saving = false;
  RoundingMode _rounding = RoundingMode.defaultMode;

  BillDetail? get detail => _detail;
  bool get loading => _loading;
  bool get saving => _saving;

  /// The rounding mode used for the live preview. Set from the current settings
  /// by the screen; a plain setter so it can be updated during build without
  /// triggering a rebuild loop.
  set rounding(RoundingMode mode) => _rounding = mode;

  /// People shown in the participant picker: active people, plus anyone already
  /// selected on this bill (so a since-deactivated participant of an existing
  /// bill stays visible and can still be toggled off).
  List<Person> get allPeople {
    final selected = selectedPersonIds;
    return List.unmodifiable(
      _allPeople.where((p) => p.active || selected.contains(p.id)),
    );
  }

  /// The bill's current participants (as [Person] records).
  List<Person> get participants => _detail?.people ?? const [];

  /// Ids of the currently selected participants.
  Set<int> get selectedPersonIds =>
      _detail?.participants.map((p) => p.personId).toSet() ?? const {};

  List<BillItem> get items => _detail?.items ?? const [];
  List<PartyContribution> get contributions =>
      _detail?.contributions ?? const [];

  /// The current split result, recomputed from the in-memory draft.
  Settlement get preview => _detail == null
      ? const Settlement(shares: [])
      : _splitService.split(_detail!, rounding: _rounding);

  Future<void> load(int billId) async {
    _loading = true;
    notifyListeners();
    _detail = await _repository.getBillDetail(billId);
    _allPeople = await _personRepository.getAll();
    _loading = false;
    notifyListeners();
  }

  Person? personById(int id) => _detail?.personById(id);

  // --- Title ---------------------------------------------------------------

  /// Updates the bill title. No notify — nothing on screen derives from the
  /// title, so the text field keeps its own state while typing.
  void setTitle(String title) {
    final d = _detail;
    if (d == null) return;
    _detail = d.copyWith(bill: d.bill.copyWith(title: title));
  }

  // --- Participants --------------------------------------------------------

  /// Adds or removes a participant. Removing a person also drops their item
  /// assignments and contributions so the split stays consistent.
  void toggleParticipant(int personId) {
    final d = _detail;
    if (d == null) return;

    if (selectedPersonIds.contains(personId)) {
      _detail = d.copyWith(
        participants:
            d.participants.where((p) => p.personId != personId).toList(),
        people: d.people.where((p) => p.id != personId).toList(),
        items: [
          for (final item in d.items)
            item.copyWith(
              assignedPersonIds:
                  item.assignedPersonIds.where((id) => id != personId).toList(),
            ),
        ],
        contributions:
            d.contributions.where((c) => c.personId != personId).toList(),
      );
    } else {
      final person = _personById(personId, _allPeople);
      _detail = d.copyWith(
        participants: [...d.participants, BillParticipant(personId: personId)],
        people: person == null ? d.people : [...d.people, person],
      );
    }
    notifyListeners();
  }

  /// Creates a new person, saves them to the reusable list, and adds them as a
  /// participant of this bill.
  Future<void> quickAddPerson(String name) async {
    final person = await _personRepository.add(name);
    _allPeople = await _personRepository.getAll();
    final d = _detail;
    if (d != null && person.id != null) {
      _detail = d.copyWith(
        participants: [...d.participants, BillParticipant(personId: person.id!)],
        people: [...d.people, person],
      );
    }
    notifyListeners();
  }

  Person? _personById(int id, List<Person> people) {
    for (final person in people) {
      if (person.id == id) return person;
    }
    return null;
  }

  // --- Equal ---------------------------------------------------------------

  void setTotal(double total) {
    final d = _detail;
    if (d == null) return;
    _detail = d.copyWith(bill: d.bill.copyWith(totalAmount: total));
    notifyListeners();
  }

  // --- Itemized ------------------------------------------------------------

  void addItem(BillItem item) {
    final d = _detail;
    if (d == null) return;
    _detail = d.copyWith(items: [...d.items, item]);
    notifyListeners();
  }

  void updateItem(int index, BillItem item) {
    final d = _detail;
    if (d == null) return;
    final items = [...d.items];
    items[index] = item;
    _detail = d.copyWith(items: items);
    notifyListeners();
  }

  void removeItem(int index) {
    final d = _detail;
    if (d == null) return;
    final items = [...d.items]..removeAt(index);
    _detail = d.copyWith(items: items);
    notifyListeners();
  }

  void setPaidAmount(int personId, double amount) {
    final d = _detail;
    if (d == null) return;
    final participants = [
      for (final p in d.participants)
        p.personId == personId ? p.copyWith(paidAmount: amount) : p,
    ];
    _detail = d.copyWith(participants: participants);
    notifyListeners();
  }

  double paidAmountFor(int personId) {
    final d = _detail;
    if (d == null) return 0;
    for (final p in d.participants) {
      if (p.personId == personId) return p.paidAmount;
    }
    return 0;
  }

  // --- Party ---------------------------------------------------------------

  void addContribution(PartyContribution contribution) {
    final d = _detail;
    if (d == null) return;
    _detail = d.copyWith(contributions: [...d.contributions, contribution]);
    notifyListeners();
  }

  void removeContribution(int index) {
    final d = _detail;
    if (d == null) return;
    final list = [...d.contributions]..removeAt(index);
    _detail = d.copyWith(contributions: list);
    notifyListeners();
  }

  // --- Persistence ---------------------------------------------------------

  /// Reconciles derived fields (total, cached paid amounts) and saves.
  Future<void> save() async {
    final d = _detail;
    if (d == null) return;
    _saving = true;
    notifyListeners();

    var updated = d;
    switch (d.bill.type) {
      case BillType.equal:
        // total is entered directly; nothing to derive.
        break;
      case BillType.itemized:
        final total = d.items.fold<double>(0, (sum, i) => sum + i.lineTotal);
        updated = updated.copyWith(bill: d.bill.copyWith(totalAmount: total));
        break;
      case BillType.party:
        updated = _reconcileParty(d);
        break;
    }

    updated =
        updated.copyWith(bill: updated.bill.copyWith(title: d.bill.title.trim()));

    await _repository.save(updated);
    _detail = updated;
    _saving = false;
    notifyListeners();
  }

  /// For party bills, cache each participant's paid amount as the sum of their
  /// contributions and set the grand total.
  BillDetail _reconcileParty(BillDetail d) {
    final paidByPerson = <int, double>{};
    for (final c in d.contributions) {
      paidByPerson[c.personId] = (paidByPerson[c.personId] ?? 0) + c.amount;
    }
    final participants = [
      for (final p in d.participants)
        p.copyWith(paidAmount: paidByPerson[p.personId] ?? 0),
    ];
    final total =
        d.contributions.fold<double>(0, (sum, c) => sum + c.amount);
    return d.copyWith(
      bill: d.bill.copyWith(totalAmount: total),
      participants: participants,
    );
  }
}
