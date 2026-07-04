import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_schema.dart';
import '../../../shared/models/bill.dart';
import '../../../shared/models/bill_detail.dart';
import '../../../shared/models/bill_item.dart';
import '../../../shared/models/bill_participant.dart';
import '../../../shared/models/party_contribution.dart';
import '../../../shared/models/person.dart';

/// Data-access object for a bill and all its child rows. Writes happen inside a
/// single transaction so a bill and its participants/items/contributions are
/// always saved consistently.
class BillDao {
  BillDao(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<Database> get _db => _appDatabase.database;

  Future<List<Bill>> getBills() async {
    final db = await _db;
    final rows = await db.query(Db.tableBill, orderBy: '${Db.billUpdatedAt} DESC');
    return rows.map(Bill.fromMap).toList();
  }

  Future<BillDetail?> getDetail(int billId) async {
    final db = await _db;
    final billRows = await db.query(
      Db.tableBill,
      where: '${Db.billId} = ?',
      whereArgs: [billId],
      limit: 1,
    );
    if (billRows.isEmpty) return null;
    final bill = Bill.fromMap(billRows.first);

    final participantRows = await db.query(
      Db.tableBillParticipant,
      where: '${Db.participantBillId} = ?',
      whereArgs: [billId],
    );
    final participants = participantRows.map(BillParticipant.fromMap).toList();

    final itemRows = await db.query(
      Db.tableBillItem,
      where: '${Db.itemBillId} = ?',
      whereArgs: [billId],
    );
    final items = <BillItem>[];
    for (final row in itemRows) {
      final itemId = row[Db.itemId] as int;
      final assignmentRows = await db.query(
        Db.tableItemAssignment,
        columns: [Db.assignmentPersonId],
        where: '${Db.assignmentItemId} = ?',
        whereArgs: [itemId],
      );
      final assigned = assignmentRows
          .map((r) => r[Db.assignmentPersonId] as int)
          .toList();
      items.add(BillItem.fromMap(row, assignedPersonIds: assigned));
    }

    final contributionRows = await db.query(
      Db.tableContribution,
      where: '${Db.contributionBillId} = ?',
      whereArgs: [billId],
    );
    final contributions =
        contributionRows.map(PartyContribution.fromMap).toList();

    // Load the Person records for every participant.
    final people = await _peopleByIds(
      db,
      participants.map((p) => p.personId).toSet(),
    );

    return BillDetail(
      bill: bill,
      participants: participants,
      people: people,
      items: items,
      contributions: contributions,
    );
  }

  Future<List<Person>> _peopleByIds(Database db, Set<int> ids) async {
    if (ids.isEmpty) return const [];
    final placeholders = List.filled(ids.length, '?').join(', ');
    final rows = await db.query(
      Db.tablePerson,
      where: '${Db.personId} IN ($placeholders)',
      whereArgs: ids.toList(),
    );
    return rows.map(Person.fromMap).toList();
  }

  /// Inserts or updates the whole bill aggregate atomically and returns the
  /// bill id.
  Future<int> save(BillDetail detail) async {
    final db = await _db;
    return db.transaction((txn) async {
      final billMap = detail.bill.toMap();
      int billId;
      if (detail.bill.id == null) {
        billId = await txn.insert(Db.tableBill, billMap);
      } else {
        billId = detail.bill.id!;
        await txn.update(
          Db.tableBill,
          billMap,
          where: '${Db.billId} = ?',
          whereArgs: [billId],
        );
      }

      // Replace participants.
      await txn.delete(
        Db.tableBillParticipant,
        where: '${Db.participantBillId} = ?',
        whereArgs: [billId],
      );
      for (final participant in detail.participants) {
        await txn.insert(
          Db.tableBillParticipant,
          participant.copyWith(billId: billId).toMap()..remove(Db.participantId),
        );
      }

      // Replace items and their assignments (assignments cascade on delete).
      await txn.delete(
        Db.tableBillItem,
        where: '${Db.itemBillId} = ?',
        whereArgs: [billId],
      );
      for (final item in detail.items) {
        final itemId = await txn.insert(
          Db.tableBillItem,
          item.copyWith(billId: billId).toMap()..remove(Db.itemId),
        );
        for (final personId in item.assignedPersonIds) {
          await txn.insert(Db.tableItemAssignment, {
            Db.assignmentItemId: itemId,
            Db.assignmentPersonId: personId,
          });
        }
      }

      // Replace contributions.
      await txn.delete(
        Db.tableContribution,
        where: '${Db.contributionBillId} = ?',
        whereArgs: [billId],
      );
      for (final contribution in detail.contributions) {
        await txn.insert(
          Db.tableContribution,
          contribution.copyWith(billId: billId).toMap()
            ..remove(Db.contributionId),
        );
      }

      return billId;
    });
  }

  Future<void> delete(int billId) async {
    final db = await _db;
    await db.delete(
      Db.tableBill,
      where: '${Db.billId} = ?',
      whereArgs: [billId],
    );
  }
}
