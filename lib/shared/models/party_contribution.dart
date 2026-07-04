import '../../core/database/database_schema.dart';

/// One thing a person paid for in a party bill (e.g. "Alice paid 300 for
/// drinks"). One person can log several contributions.
class PartyContribution {
  const PartyContribution({
    this.id,
    this.billId,
    required this.personId,
    this.label,
    required this.amount,
  });

  final int? id;
  final int? billId;
  final int personId;
  final String? label;
  final double amount;

  PartyContribution copyWith({
    int? id,
    int? billId,
    int? personId,
    String? label,
    double? amount,
  }) {
    return PartyContribution(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      personId: personId ?? this.personId,
      label: label ?? this.label,
      amount: amount ?? this.amount,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) Db.contributionId: id,
      Db.contributionBillId: billId,
      Db.contributionPersonId: personId,
      Db.contributionLabel: label,
      Db.contributionAmount: amount,
    };
  }

  factory PartyContribution.fromMap(Map<String, Object?> map) {
    return PartyContribution(
      id: map[Db.contributionId] as int?,
      billId: map[Db.contributionBillId] as int?,
      personId: map[Db.contributionPersonId] as int,
      label: map[Db.contributionLabel] as String?,
      amount: (map[Db.contributionAmount] as num?)?.toDouble() ?? 0,
    );
  }
}
