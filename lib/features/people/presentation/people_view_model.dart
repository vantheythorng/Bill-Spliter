import 'package:flutter/foundation.dart';

import '../../../shared/models/person.dart';
import '../../../core/repository/people/person_repository.dart';

/// View model for the People screen — loads and mutates the reusable person
/// list. Injected with a [PersonRepository].
class PeopleViewModel extends ChangeNotifier {
  PeopleViewModel(this._repository);

  final PersonRepository _repository;

  List<Person> _people = [];
  Set<int> _referencedIds = {};
  bool _loading = false;

  List<Person> get people => List.unmodifiable(_people);
  bool get loading => _loading;
  bool get isEmpty => !_loading && _people.isEmpty;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _people = await _repository.getAll();
    _referencedIds = await _repository.referencedIds();
    _loading = false;
    notifyListeners();
  }

  Future<Person> addPerson(String name) async {
    final person = await _repository.add(name);
    await load();
    return person;
  }

  Future<void> renamePerson(Person person, String newName) async {
    await _repository.update(person.copyWith(name: newName.trim()));
    await load();
  }

  /// Whether the person is referenced by existing bills. Referenced people
  /// cannot be deleted — only deactivated to hide them from new bills.
  bool isReferenced(Person person) =>
      person.id != null && _referencedIds.contains(person.id);

  /// Deletes a person entirely. Only valid for people with no bill history;
  /// the UI blocks deletion of referenced people.
  Future<void> deletePerson(Person person) async {
    if (person.id == null) return;
    await _repository.delete(person.id!);
    await load();
  }

  /// Hides or restores the person in the participant picker.
  Future<void> setActive(Person person, bool active) async {
    if (person.id == null) return;
    await _repository.setActive(person.id!, active);
    await load();
  }
}
