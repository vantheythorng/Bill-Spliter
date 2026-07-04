import '../../core/database/database_schema.dart';

/// A line item on an itemized bill. [assignedPersonIds] holds the people who
/// share this item (loaded from `bill_item_assignment`).
class BillItem {
  const BillItem({
    this.id,
    this.billId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.assignedPersonIds = const [],
  });

  final int? id;
  final int? billId;
  final String name;
  final double price;
  final int quantity;
  final List<int> assignedPersonIds;

  /// Total cost of this line (price × quantity).
  double get lineTotal => price * quantity;

  BillItem copyWith({
    int? id,
    int? billId,
    String? name,
    double? price,
    int? quantity,
    List<int>? assignedPersonIds,
  }) {
    return BillItem(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      assignedPersonIds: assignedPersonIds ?? this.assignedPersonIds,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) Db.itemId: id,
      Db.itemBillId: billId,
      Db.itemName: name,
      Db.itemPrice: price,
      Db.itemQuantity: quantity,
    };
  }

  factory BillItem.fromMap(
    Map<String, Object?> map, {
    List<int> assignedPersonIds = const [],
  }) {
    return BillItem(
      id: map[Db.itemId] as int?,
      billId: map[Db.itemBillId] as int?,
      name: map[Db.itemName] as String,
      price: (map[Db.itemPrice] as num?)?.toDouble() ?? 0,
      quantity: (map[Db.itemQuantity] as int?) ?? 1,
      assignedPersonIds: assignedPersonIds,
    );
  }
}
