import '../../../shared/models/person.dart';

/// Abstract contract for reading and mutating the reusable people list. View
/// models depend on this interface, not the concrete SQLite implementation.
abstract class PersonRepository {
  Future<List<Person>> getAll();

  /// Creates a new person, returning it with its assigned id.
  Future<Person> add(String name);

  Future<void> update(Person person);

  Future<void> delete(int id);

  /// Hides ([active] = false) or restores the person in the participant picker
  /// without touching their existing bill history.
  Future<void> setActive(int id, bool active);

  /// Whether the person appears in any existing bill.
  Future<bool> isReferenced(int id);

  /// The ids of every person referenced by an existing bill. Referenced people
  /// cannot be deleted — only deactivated.
  Future<Set<int>> referencedIds();
}
