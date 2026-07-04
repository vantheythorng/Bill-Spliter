import '../../core/database/database_schema.dart';

/// Links a [Person] to a [Bill] and records what they actually paid.
class BillParticipant {
  const BillParticipant({
    this.id,
    this.billId,
    required this.personId,
    this.paidAmount = 0,
  });

  final int? id;
  final int? billId;
  final int personId;

  /// What this person actually paid (itemized & party modes).
  final double paidAmount;

  BillParticipant copyWith({
    int? id,
    int? billId,
    int? personId,
    double? paidAmount,
  }) {
    return BillParticipant(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      personId: personId ?? this.personId,
      paidAmount: paidAmount ?? this.paidAmount,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) Db.participantId: id,
      Db.participantBillId: billId,
      Db.participantPersonId: personId,
      Db.participantPaidAmount: paidAmount,
    };
  }

  factory BillParticipant.fromMap(Map<String, Object?> map) {
    return BillParticipant(
      id: map[Db.participantId] as int?,
      billId: map[Db.participantBillId] as int?,
      personId: map[Db.participantPersonId] as int,
      paidAmount: (map[Db.participantPaidAmount] as num?)?.toDouble() ?? 0,
    );
  }
}
