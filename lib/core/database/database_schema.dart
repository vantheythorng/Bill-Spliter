/// Central definition of table and column names plus the DDL used to build the
/// SQLite schema. Keeping this in one place avoids stringly-typed drift between
/// the DAOs.
class Db {
  const Db._();

  // person
  static const String tablePerson = 'person';
  static const String personId = 'id';
  static const String personName = 'name';
  static const String personColorSeed = 'color_seed';
  static const String personCreatedAt = 'created_at';
  static const String personActive = 'active';

  // bill
  static const String tableBill = 'bill';
  static const String billId = 'id';
  static const String billTitle = 'title';
  static const String billType = 'type';
  static const String billTotalAmount = 'total_amount';
  static const String billCurrencyCode = 'currency_code';
  static const String billCreatedAt = 'created_at';
  static const String billUpdatedAt = 'updated_at';

  // bill_participant
  static const String tableBillParticipant = 'bill_participant';
  static const String participantId = 'id';
  static const String participantBillId = 'bill_id';
  static const String participantPersonId = 'person_id';
  static const String participantPaidAmount = 'paid_amount';

  // bill_item
  static const String tableBillItem = 'bill_item';
  static const String itemId = 'id';
  static const String itemBillId = 'bill_id';
  static const String itemName = 'name';
  static const String itemPrice = 'price';
  static const String itemQuantity = 'quantity';

  // bill_item_assignment
  static const String tableItemAssignment = 'bill_item_assignment';
  static const String assignmentId = 'id';
  static const String assignmentItemId = 'bill_item_id';
  static const String assignmentPersonId = 'person_id';

  // party_contribution
  static const String tableContribution = 'party_contribution';
  static const String contributionId = 'id';
  static const String contributionBillId = 'bill_id';
  static const String contributionPersonId = 'person_id';
  static const String contributionLabel = 'label';
  static const String contributionAmount = 'amount';

  /// Statements executed when the database is first created.
  static const List<String> createStatements = [
    '''
    CREATE TABLE $tablePerson (
      $personId INTEGER PRIMARY KEY AUTOINCREMENT,
      $personName TEXT NOT NULL,
      $personColorSeed INTEGER NOT NULL,
      $personCreatedAt INTEGER NOT NULL,
      $personActive INTEGER NOT NULL DEFAULT 1
    )
    ''',
    '''
    CREATE TABLE $tableBill (
      $billId INTEGER PRIMARY KEY AUTOINCREMENT,
      $billTitle TEXT NOT NULL,
      $billType TEXT NOT NULL,
      $billTotalAmount REAL NOT NULL DEFAULT 0,
      $billCurrencyCode TEXT,
      $billCreatedAt INTEGER NOT NULL,
      $billUpdatedAt INTEGER NOT NULL
    )
    ''',
    '''
    CREATE TABLE $tableBillParticipant (
      $participantId INTEGER PRIMARY KEY AUTOINCREMENT,
      $participantBillId INTEGER NOT NULL,
      $participantPersonId INTEGER NOT NULL,
      $participantPaidAmount REAL NOT NULL DEFAULT 0,
      FOREIGN KEY ($participantBillId) REFERENCES $tableBill ($billId) ON DELETE CASCADE,
      FOREIGN KEY ($participantPersonId) REFERENCES $tablePerson ($personId)
    )
    ''',
    '''
    CREATE TABLE $tableBillItem (
      $itemId INTEGER PRIMARY KEY AUTOINCREMENT,
      $itemBillId INTEGER NOT NULL,
      $itemName TEXT NOT NULL,
      $itemPrice REAL NOT NULL,
      $itemQuantity INTEGER NOT NULL DEFAULT 1,
      FOREIGN KEY ($itemBillId) REFERENCES $tableBill ($billId) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE $tableItemAssignment (
      $assignmentId INTEGER PRIMARY KEY AUTOINCREMENT,
      $assignmentItemId INTEGER NOT NULL,
      $assignmentPersonId INTEGER NOT NULL,
      FOREIGN KEY ($assignmentItemId) REFERENCES $tableBillItem ($itemId) ON DELETE CASCADE,
      FOREIGN KEY ($assignmentPersonId) REFERENCES $tablePerson ($personId)
    )
    ''',
    '''
    CREATE TABLE $tableContribution (
      $contributionId INTEGER PRIMARY KEY AUTOINCREMENT,
      $contributionBillId INTEGER NOT NULL,
      $contributionPersonId INTEGER NOT NULL,
      $contributionLabel TEXT,
      $contributionAmount REAL NOT NULL,
      FOREIGN KEY ($contributionBillId) REFERENCES $tableBill ($billId) ON DELETE CASCADE,
      FOREIGN KEY ($contributionPersonId) REFERENCES $tablePerson ($personId)
    )
    ''',
  ];
}
