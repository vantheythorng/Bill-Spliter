import 'package:bill_splitter/features/bills/domain/services/split_service.dart';
import 'package:bill_splitter/shared/models/bill.dart';
import 'package:bill_splitter/shared/models/bill_detail.dart';
import 'package:bill_splitter/shared/models/bill_item.dart';
import 'package:bill_splitter/shared/models/bill_participant.dart';
import 'package:bill_splitter/shared/models/bill_type.dart';
import 'package:bill_splitter/shared/models/party_contribution.dart';
import 'package:bill_splitter/shared/models/person.dart';
import 'package:bill_splitter/shared/utils/rounding_mode.dart';
import 'package:flutter_test/flutter_test.dart';

const _splitService = SplitService();

Person _person(int id) => Person(id: id, name: 'P$id', colorSeed: id);

BillDetail _detail({
  required BillType type,
  double total = 0,
  List<int> personIds = const [1, 2, 3],
  List<BillParticipant> participants = const [],
  List<BillItem> items = const [],
  List<PartyContribution> contributions = const [],
}) {
  return BillDetail(
    bill: Bill(title: 'Test', type: type, totalAmount: total),
    people: personIds.map(_person).toList(),
    participants: participants.isNotEmpty
        ? participants
        : personIds.map((id) => BillParticipant(personId: id)).toList(),
    items: items,
    contributions: contributions,
  );
}

void main() {
  group('equal split', () {
    test('divides the total with largest-remainder so shares sum to total', () {
      final result = _splitService.split(
        _detail(type: BillType.equal, total: 10.0, personIds: [1, 2, 3]),
      );
      final owed = result.shares.map((s) => s.owed).toList();
      expect(owed, [3.34, 3.33, 3.33]);
      final sum = owed.reduce((a, b) => a + b);
      expect(sum, closeTo(10.0, 0.0001));
      expect(result.transfers, isEmpty);
    });

    test('100 among 3 gives 33.34 / 33.33 / 33.33 and reconciles to 100', () {
      final result = _splitService.split(
        _detail(type: BillType.equal, total: 100.0, personIds: [1, 2, 3]),
      );
      expect(result.shares.map((s) => s.owed).toList(), [33.34, 33.33, 33.33]);
      expect(
        result.shares.fold<double>(0, (sum, s) => sum + s.owed),
        closeTo(100.0, 0.0001),
      );
    });

    test('roundingDelta reports extra / short / none per rounding mode', () {
      final detail = _detail(type: BillType.equal, total: 100.0, personIds: [1, 2, 3]);

      // Exact: adds up to the total.
      expect(
        _splitService.split(detail).roundingDelta,
        closeTo(0.0, 0.0001),
      );
      // Round up: 33.34 × 3 = 100.02 → 0.02 extra.
      expect(
        _splitService.split(detail, rounding: RoundingMode.roundUp).roundingDelta,
        closeTo(0.02, 0.0001),
      );
      // Round down: 33.33 × 3 = 99.99 → 0.01 short.
      expect(
        _splitService
            .split(detail, rounding: RoundingMode.roundDown)
            .roundingDelta,
        closeTo(-0.01, 0.0001),
      );
    });
  });

  group('itemized split', () {
    test('assigns item cost to its people and settles up', () {
      // Item A (30) shared by 1 & 2; item B (10) by person 3.
      // Person 1 paid the whole 40.
      final result = _splitService.split(_detail(
        type: BillType.itemized,
        personIds: [1, 2, 3],
        participants: [
          const BillParticipant(personId: 1, paidAmount: 40),
          const BillParticipant(personId: 2),
          const BillParticipant(personId: 3),
        ],
        items: [
          const BillItem(name: 'A', price: 30, assignedPersonIds: [1, 2]),
          const BillItem(name: 'B', price: 10, assignedPersonIds: [3]),
        ],
      ));

      expect(result.shareFor(1)!.owed, 15.0);
      expect(result.shareFor(2)!.owed, 15.0);
      expect(result.shareFor(3)!.owed, 10.0);

      // Person 1 paid 40, owes 15 → is owed 25 back from 2 (15) and 3 (10).
      final totalTransferred =
          result.transfers.fold<double>(0, (sum, t) => sum + t.amount);
      expect(totalTransferred, 25.0);
      expect(result.transfers.every((t) => t.toPersonId == 1), isTrue);
    });
  });

  group('party split', () {
    test('splits the pot equally and reimburses overspenders', () {
      // Alice(1) paid 300, Bob(2) paid 120, Cara(3) paid 0. Total 420 / 3 = 140.
      final result = _splitService.split(_detail(
        type: BillType.party,
        personIds: [1, 2, 3],
        contributions: [
          const PartyContribution(personId: 1, amount: 300),
          const PartyContribution(personId: 2, amount: 120),
        ],
      ));

      expect(result.shareFor(1)!.owed, 140.0);
      expect(result.shareFor(1)!.balance, 160.0); // paid 300 - 140
      expect(result.shareFor(2)!.balance, closeTo(-20.0, 0.0001));
      expect(result.shareFor(3)!.balance, -140.0);

      // Debtors 2 and 3 together repay 160 to creditor 1.
      final total =
          result.transfers.fold<double>(0, (sum, t) => sum + t.amount);
      expect(total, 160.0);
      expect(result.transfers.every((t) => t.toPersonId == 1), isTrue);
    });
  });
}
