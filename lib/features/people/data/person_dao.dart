import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_schema.dart';
import '../../../shared/models/person.dart';

/// Data-access object for the `person` table and the queries needed to enforce
/// the soft-delete guard (checking whether a person is referenced elsewhere).
class PersonDao {
  PersonDao(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<Database> get _db => _appDatabase.database;

  Future<List<Person>> getAll() async {
    final db = await _db;
    final rows = await db.query(Db.tablePerson, orderBy: '${Db.personName} COLLATE NOCASE ASC');
    return rows.map(Person.fromMap).toList();
  }

  Future<Person> insert(Person person) async {
    final db = await _db;
    final id = await db.insert(Db.tablePerson, person.toMap());
    return person.copyWith(id: id);
  }

  Future<void> update(Person person) async {
    final db = await _db;
    await db.update(
      Db.tablePerson,
      person.toMap(),
      where: '${Db.personId} = ?',
      whereArgs: [person.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete(
      Db.tablePerson,
      where: '${Db.personId} = ?',
      whereArgs: [id],
    );
  }

  /// Whether the person is referenced by any bill (participant, item
  /// assignment, or contribution) and so must be kept for historical integrity.
  Future<bool> isReferenced(int id) async {
    final db = await _db;
    Future<int> count(String table, String column) async {
      final result = await db.rawQuery(
        'SELECT COUNT(*) AS c FROM $table WHERE $column = ?',
        [id],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    }

    final total = await count(Db.tableBillParticipant, Db.participantPersonId) +
        await count(Db.tableItemAssignment, Db.assignmentPersonId) +
        await count(Db.tableContribution, Db.contributionPersonId);
    return total > 0;
  }
}
