import '../../../shared/models/bill_detail.dart';
import '../../../shared/models/bill_type.dart';
import '../../../shared/models/settlement.dart';
import '../../../shared/utils/money.dart';
import '../../../shared/utils/rounding_mode.dart';
import 'settle_up_service.dart';

/// Turns a [BillDetail] into a [Settlement] — each person's owed/paid amounts
/// plus the minimal transfers to settle up. Pure and unit-testable.
class SplitService {
  const SplitService({this.settleUp = const SettleUpService()});

  final SettleUpService settleUp;

  Settlement split(
    BillDetail detail, {
    RoundingMode rounding = RoundingMode.largestRemainder,
  }) {
    switch (detail.bill.type) {
      case BillType.equal:
        return _splitEqual(detail, rounding);
      case BillType.itemized:
        return _splitItemized(detail, rounding);
      case BillType.party:
        return _splitParty(detail, rounding);
    }
  }

  Settlement _splitEqual(BillDetail detail, RoundingMode rounding) {
    final personIds = detail.participantPersonIds;
    if (personIds.isEmpty) return const Settlement(shares: []);

    final owedCents = Money.distribute(
      Money.toCents(detail.bill.totalAmount),
      personIds.length,
      mode: rounding,
    );

    final shares = [
      for (var i = 0; i < personIds.length; i++)
        PersonShare(
          personId: personIds[i],
          owed: Money.fromCents(owedCents[i]),
          paid: 0,
        ),
    ];
    // Equal split just divides the total; there is no settle-up step.
    final owedSum = owedCents.fold<int>(0, (sum, c) => sum + c);
    return Settlement(
      shares: shares,
      roundingDelta:
          Money.fromCents(owedSum - Money.toCents(detail.bill.totalAmount)),
    );
  }

  Settlement _splitItemized(BillDetail detail, RoundingMode rounding) {
    final personIds = detail.participantPersonIds;
    if (personIds.isEmpty) return const Settlement(shares: []);

    final owedByPerson = {for (final id in personIds) id: 0};
    var trueTotalCents = 0;

    // Split each item's line total equally among its assigned people, in cents,
    // so per-item rounding never drifts from the item total.
    for (final item in detail.items) {
      final assigned =
          item.assignedPersonIds.where(personIds.contains).toList();
      if (assigned.isEmpty) continue;
      trueTotalCents += Money.toCents(item.lineTotal);
      final shares = Money.distribute(
        Money.toCents(item.lineTotal),
        assigned.length,
        mode: rounding,
      );
      for (var i = 0; i < assigned.length; i++) {
        owedByPerson[assigned[i]] =
            (owedByPerson[assigned[i]] ?? 0) + shares[i];
      }
    }

    final paidByPerson = {
      for (final participant in detail.participants)
        participant.personId: Money.toCents(participant.paidAmount),
    };

    return _buildSettlement(personIds, owedByPerson, paidByPerson, trueTotalCents);
  }

  Settlement _splitParty(BillDetail detail, RoundingMode rounding) {
    final personIds = detail.participantPersonIds;
    if (personIds.isEmpty) return const Settlement(shares: []);

    final paidByPerson = {for (final id in personIds) id: 0};
    for (final contribution in detail.contributions) {
      paidByPerson[contribution.personId] =
          (paidByPerson[contribution.personId] ?? 0) +
              Money.toCents(contribution.amount);
    }

    final grandTotalCents =
        paidByPerson.values.fold<int>(0, (sum, cents) => sum + cents);
    final equalShares =
        Money.distribute(grandTotalCents, personIds.length, mode: rounding);
    final owedByPerson = {
      for (var i = 0; i < personIds.length; i++) personIds[i]: equalShares[i],
    };

    return _buildSettlement(
        personIds, owedByPerson, paidByPerson, grandTotalCents);
  }

  Settlement _buildSettlement(
    List<int> personIds,
    Map<int, int> owedCents,
    Map<int, int> paidCents,
    int referenceTotalCents,
  ) {
    final shares = [
      for (final id in personIds)
        PersonShare(
          personId: id,
          owed: Money.fromCents(owedCents[id] ?? 0),
          paid: Money.fromCents(paidCents[id] ?? 0),
        ),
    ];

    final balances = {
      for (final share in shares) share.personId: share.balance,
    };

    final owedSum = owedCents.values.fold<int>(0, (sum, c) => sum + c);
    return Settlement(
      shares: shares,
      transfers: settleUp.settle(balances),
      roundingDelta: Money.fromCents(owedSum - referenceTotalCents),
    );
  }
}
