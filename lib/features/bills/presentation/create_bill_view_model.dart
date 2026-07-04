import 'package:flutter/foundation.dart';

import '../../../shared/models/bill.dart';
import '../../../shared/models/bill_detail.dart';
import '../../../shared/models/bill_participant.dart';
import '../../../shared/models/bill_type.dart';
import '../../../shared/models/person.dart';
import '../../people/domain/person_repository.dart';
import '../../settings/domain/supported_currencies.dart';
import '../domain/bill_repository.dart';

/// Drives the first step of bill creation: title, split type and participant
/// selection (with inline quick-add). Persists a draft bill and returns its id
/// so the matching editor can continue.
class CreateBillViewModel extends ChangeNotifier {
  CreateBillViewModel(this._personRepository, this._billRepository);

  final PersonRepository _personRepository;
  final BillRepository _billRepository;

  List<Person> _people = [];
  final Set<int> _selectedPersonIds = {};
  String _title = '';
  BillType _type = BillType.equal;
  bool _loading = false;

  /// The currency chosen for this bill (always set — picked in the create flow).
  String _currencyCode = kDefaultCurrencyCode;

  List<Person> get people => List.unmodifiable(_people);
  Set<int> get selectedPersonIds => _selectedPersonIds;
  String get title => _title;
  BillType get type => _type;
  bool get loading => _loading;

  String get currencyCode => _currencyCode;

  bool get canProceed =>
      _title.trim().isNotEmpty && _selectedPersonIds.isNotEmpty;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _people = await _personRepository.getAll();
    _loading = false;
    notifyListeners();
  }

  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setType(BillType type) {
    _type = type;
    notifyListeners();
  }

  void setCurrency(String code) {
    _currencyCode = code;
    notifyListeners();
  }

  void toggleParticipant(int personId) {
    if (!_selectedPersonIds.remove(personId)) {
      _selectedPersonIds.add(personId);
    }
    notifyListeners();
  }

  /// Creates a new person from [name], selecting them immediately. The person
  /// is saved to the reusable list so pre-creation is never required.
  Future<void> quickAddPerson(String name) async {
    final person = await _personRepository.add(name);
    _people = await _personRepository.getAll();
    if (person.id != null) _selectedPersonIds.add(person.id!);
    notifyListeners();
  }

  /// Persists the draft bill and returns its id.
  Future<int> createDraft() async {
    final selected =
        _people.where((p) => _selectedPersonIds.contains(p.id)).toList();
    final detail = BillDetail(
      bill: Bill(
        title: _title.trim(),
        type: _type,
        currencyCode: _currencyCode,
      ),
      participants: [
        for (final person in selected)
          BillParticipant(personId: person.id!),
      ],
      people: selected,
    );
    return _billRepository.save(detail);
  }
}
