import '../../core/database/database_schema.dart';
import 'bill_type.dart';

/// A saved bill. Line items, participants and contributions live in their own
/// tables and are loaded into [BillDetail] when needed.
class Bill {
  const Bill({
    this.id,
    required this.title,
    required this.type,
    this.totalAmount = 0,
    this.deliveryFee = 0,
    this.currencyCode,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String title;
  final BillType type;

  /// For equal bills this is entered directly. For party bills it is derived
  /// from the sum of contributions. For itemized bills it is the computed sum
  /// (item lines + packaging fees + [deliveryFee]).
  final double totalAmount;

  /// An order-level delivery fee (itemized bills). Split equally across all
  /// participants; `0` when there is none.
  final double deliveryFee;

  /// The currency this bill is recorded in. `null` means "follow the app's
  /// default currency" (the system option); a code means a manually chosen
  /// currency fixed to this bill.
  final String? currencyCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Bill copyWith({
    int? id,
    String? title,
    BillType? type,
    double? totalAmount,
    double? deliveryFee,
    String? currencyCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bill(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      currencyCode: currencyCode ?? this.currencyCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return {
      if (id != null) Db.billId: id,
      Db.billTitle: title,
      Db.billType: type.storageValue,
      Db.billTotalAmount: totalAmount,
      Db.billDeliveryFee: deliveryFee,
      Db.billCurrencyCode: currencyCode,
      Db.billCreatedAt: (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
      Db.billUpdatedAt: now,
    };
  }

  factory Bill.fromMap(Map<String, Object?> map) {
    return Bill(
      id: map[Db.billId] as int?,
      title: map[Db.billTitle] as String,
      type: BillType.fromStorage(map[Db.billType] as String),
      totalAmount: (map[Db.billTotalAmount] as num?)?.toDouble() ?? 0,
      deliveryFee: (map[Db.billDeliveryFee] as num?)?.toDouble() ?? 0,
      currencyCode: map[Db.billCurrencyCode] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map[Db.billCreatedAt] as int?) ?? 0,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (map[Db.billUpdatedAt] as int?) ?? 0,
      ),
    );
  }
}
