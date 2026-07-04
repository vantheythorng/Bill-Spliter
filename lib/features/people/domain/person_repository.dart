import '../../../shared/models/person.dart';

/// Abstract contract for reading and mutating the reusable people list. View
/// models depend on this interface, not the concrete SQLite implementation.
abstract class PersonRepository {
  Future<List<Person>> getAll();

  /// Creates a new person, returning it with its assigned id.
  Future<Person> add(String name);

  Future<void> update(Person person);

  Future<void> delete(int id);

  /// Whether the person appears in any existing bill.
  Future<bool> isReferenced(int id);
}
