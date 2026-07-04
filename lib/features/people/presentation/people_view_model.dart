import 'package:flutter/foundation.dart';

import '../../../shared/models/person.dart';
import '../domain/person_repository.dart';

/// View model for the People screen — loads and mutates the reusable person
/// list. Injected with a [PersonRepository].
class PeopleViewModel extends ChangeNotifier {
  PeopleViewModel(this._repository);

  final PersonRepository _repository;

  List<Person> _people = [];
  bool _loading = false;

  List<Person> get people => List.unmodifiable(_people);
  bool get loading => _loading;
  bool get isEmpty => !_loading && _people.isEmpty;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _people = await _repository.getAll();
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

  /// Returns true if the person is referenced by existing bills and so should
  /// prompt a confirm-before-delete.
  Future<bool> isReferenced(Person person) {
    if (person.id == null) return Future.value(false);
    return _repository.isReferenced(person.id!);
  }

  Future<void> deletePerson(Person person) async {
    if (person.id == null) return;
    await _repository.delete(person.id!);
    await load();
  }
}
