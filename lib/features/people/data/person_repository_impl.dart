import '../../../shared/models/person.dart';
import '../domain/person_repository.dart';
import 'person_dao.dart';

class PersonRepositoryImpl implements PersonRepository {
  PersonRepositoryImpl(this._dao);

  final PersonDao _dao;

  @override
  Future<List<Person>> getAll() => _dao.getAll();

  @override
  Future<Person> add(String name) {
    final trimmed = name.trim();
    // Derive a stable avatar color seed from the name so it never changes.
    final colorSeed = trimmed.toLowerCase().hashCode & 0x7fffffff;
    return _dao.insert(Person(
      name: trimmed,
      colorSeed: colorSeed,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> update(Person person) => _dao.update(person);

  @override
  Future<void> delete(int id) => _dao.delete(id);

  @override
  Future<void> setActive(int id, bool active) => _dao.setActive(id, active);

  @override
  Future<bool> isReferenced(int id) => _dao.isReferenced(id);

  @override
  Future<Set<int>> referencedIds() => _dao.referencedIds();
}
