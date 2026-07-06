import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

/// Shared base for every data-access object: holds the [AppDatabase] and
/// exposes the lazily-opened [Database] so individual DAOs don't repeat the
/// same wiring. Subclasses query via the [db] getter.
abstract class BaseDao {
  const BaseDao(this._appDatabase);

  final AppDatabase _appDatabase;

  /// The open database, opened on first access.
  Future<Database> get db => _appDatabase.database;
}
