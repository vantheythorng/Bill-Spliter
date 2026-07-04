import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/app_constants.dart';
import 'database_schema.dart';

/// Owns the single [Database] instance and handles opening, schema creation and
/// future migrations. Registered as a lazy singleton in the service locator.
class AppDatabase {
  Database? _database;

  /// Returns the open database, opening it on first access.
  Future<Database> get database async {
    return _database ??= await _open();
  }

  Future<Database> _open() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final path = p.join(documentsDir.path, AppConstants.databaseName);

    return openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final statement in Db.createStatements) {
      batch.execute(statement);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // No migrations yet — reserved for future schema versions.
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
