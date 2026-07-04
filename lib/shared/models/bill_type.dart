/// The three ways a bill can be split.
enum BillType {
  equal('equal'),
  itemized('itemized'),
  party('party');

  const BillType(this.storageValue);

  /// Value persisted in the `bill.type` column.
  final String storageValue;

  static BillType fromStorage(String value) {
    return BillType.values.firstWhere(
      (type) => type.storageValue == value,
      orElse: () => BillType.equal,
    );
  }
}
