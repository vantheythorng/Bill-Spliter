import '../../../../shared/models/settlement.dart';
import '../../../../shared/utils/money.dart';

/// Greedy minimum-transactions settle-up. Given each person's balance
/// (positive = owed money back, negative = owes), it repeatedly matches the
/// largest creditor with the largest debtor until every balance is zero,
/// producing a small set of transfers.
///
/// Pure and framework-independent — the same algorithm serves itemized and
/// party bills, since both reduce to `paid − owed` balances.
class SettleUpService {
  const SettleUpService();

  /// [balances] maps personId → balance in currency units.
  List<Transfer> settle(Map<int, double> balances) {
    // Work in integer cents for exactness.
    final creditors = <_Node>[];
    final debtors = <_Node>[];

    balances.forEach((personId, balance) {
      final cents = Money.toCents(balance);
      if (cents > 0) {
        creditors.add(_Node(personId, cents));
      } else if (cents < 0) {
        debtors.add(_Node(personId, -cents));
      }
    });

    // Largest first so the biggest imbalances are cleared with fewer transfers.
    creditors.sort((a, b) => b.amount.compareTo(a.amount));
    debtors.sort((a, b) => b.amount.compareTo(a.amount));

    final transfers = <Transfer>[];
    var ci = 0;
    var di = 0;
    while (ci < creditors.length && di < debtors.length) {
      final creditor = creditors[ci];
      final debtor = debtors[di];
      final paidCents =
          creditor.amount < debtor.amount ? creditor.amount : debtor.amount;

      if (paidCents > 0) {
        transfers.add(Transfer(
          fromPersonId: debtor.personId,
          toPersonId: creditor.personId,
          amount: Money.fromCents(paidCents),
        ));
      }

      creditor.amount -= paidCents;
      debtor.amount -= paidCents;
      if (creditor.amount == 0) ci++;
      if (debtor.amount == 0) di++;
    }

    return transfers;
  }
}

class _Node {
  _Node(this.personId, this.amount);
  final int personId;
  int amount;
}
