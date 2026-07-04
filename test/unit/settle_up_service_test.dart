import 'package:bill_splitter/features/bills/domain/services/settle_up_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = SettleUpService();

  test('produces no transfers when everyone is settled', () {
    final transfers = service.settle({1: 0, 2: 0, 3: 0});
    expect(transfers, isEmpty);
  });

  test('matches a single debtor with a single creditor', () {
    // Person 1 is owed 10, person 2 owes 10.
    final transfers = service.settle({1: 10.0, 2: -10.0});
    expect(transfers, hasLength(1));
    expect(transfers.first.fromPersonId, 2);
    expect(transfers.first.toPersonId, 1);
    expect(transfers.first.amount, 10.0);
  });

  test('clears balances with the minimum number of transfers', () {
    // 1 and 2 each overspent 15; 3 underspent 30.
    final transfers = service.settle({1: 15.0, 2: 15.0, 3: -30.0});
    expect(transfers, hasLength(2));
    // Debtor 3 pays both creditors; totals reconcile.
    final total = transfers.fold<double>(0, (sum, t) => sum + t.amount);
    expect(total, 30.0);
    expect(transfers.every((t) => t.fromPersonId == 3), isTrue);
  });

  test('greedily matches largest creditor with largest debtor', () {
    final transfers = service.settle({1: 50.0, 2: -30.0, 3: -20.0});
    // The single creditor (1) receives from both debtors.
    expect(transfers, hasLength(2));
    final received = transfers.fold<double>(0, (sum, t) => sum + t.amount);
    expect(received, 50.0);
  });
}
