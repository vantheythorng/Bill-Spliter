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
    this.packagingFee = 0,
    this.assignedPersonIds = const [],
  });

  final int? id;
  final int? billId;
  final String name;
  final double price;
  final int quantity;

  /// A flat packaging fee for this line (charged once, not per unit). Split
  /// among the item's assigned people alongside the item cost.
  final double packagingFee;
  final List<int> assignedPersonIds;

  /// Cost of the item itself (price × quantity), excluding any packaging fee.
  double get lineTotal => price * quantity;

  /// What the item's sharers owe for this line: item cost plus the flat
  /// packaging fee.
  double get lineTotalWithFee => lineTotal + packagingFee;

  BillItem copyWith({
    int? id,
    int? billId,
    String? name,
    double? price,
    int? quantity,
    double? packagingFee,
    List<int>? assignedPersonIds,
  }) {
    return BillItem(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      packagingFee: packagingFee ?? this.packagingFee,
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
      Db.itemPackagingFee: packagingFee,
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
      packagingFee: (map[Db.itemPackagingFee] as num?)?.toDouble() ?? 0,
      assignedPersonIds: assignedPersonIds,
    );
  }
}
