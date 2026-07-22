import 'package:bill_splitter/core/services/bills/split_service.dart';
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
  double deliveryFee = 0,
  List<int> personIds = const [1, 2, 3],
  List<BillParticipant> participants = const [],
  List<BillItem> items = const [],
  List<PartyContribution> contributions = const [],
}) {
  return BillDetail(
    bill: Bill(
        title: 'Test', type: type, totalAmount: total, deliveryFee: deliveryFee),
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
    test('indivisible cent falls on the payer, split reconciles exactly', () {
      // One 10.00 item shared by A(1), B(2), C(3); A fronted the whole 10.
      // 10 / 3 → owed 3.34 / 3.33 / 3.33 (largest-remainder, sums to 10).
      final result = _splitService.split(_detail(
        type: BillType.itemized,
        personIds: [1, 2, 3],
        participants: [
          const BillParticipant(personId: 1, paidAmount: 10),
          const BillParticipant(personId: 2),
          const BillParticipant(personId: 3),
        ],
        items: [
          const BillItem(name: 'Shared', price: 10, assignedPersonIds: [1, 2, 3]),
        ],
      ));

      expect(result.shareFor(1)!.owed, 3.34);
      expect(result.shareFor(2)!.owed, 3.33);
      expect(result.shareFor(3)!.owed, 3.33);
      expect(result.roundingDelta, closeTo(0.0, 0.0001)); // sums to exactly 10

      // B and C each repay A 3.33; A keeps 3.34 of the 10 it fronted → A pays
      // the odd cent, nothing is lost or over-collected.
      final repaid =
          result.transfers.fold<double>(0, (sum, t) => sum + t.amount);
      expect(repaid, closeTo(6.66, 0.0001));
      expect(result.transfers.every((t) => t.toPersonId == 1), isTrue);
    });

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

    test('per-item packaging fee is split among that item\'s sharers', () {
      // Item A: price 30 + packaging 3 → 33, shared by 1 & 2 → 16.5 each.
      // Item B: price 10 (no fee), person 3 → 10.
      final result = _splitService.split(_detail(
        type: BillType.itemized,
        personIds: [1, 2, 3],
        items: [
          const BillItem(
              name: 'A', price: 30, packagingFee: 3, assignedPersonIds: [1, 2]),
          const BillItem(name: 'B', price: 10, assignedPersonIds: [3]),
        ],
      ));

      expect(result.shareFor(1)!.owed, 16.5);
      expect(result.shareFor(2)!.owed, 16.5);
      expect(result.shareFor(3)!.owed, 10.0);
      expect(result.roundingDelta, closeTo(0.0, 0.0001)); // 33 + 10 = 43
    });

    test('order-level delivery fee is split equally across everyone', () {
      // Items: A 30 → {1,2} (15 each), B 10 → {3}. Delivery 9 over 3 → +3 each.
      final result = _splitService.split(_detail(
        type: BillType.itemized,
        personIds: [1, 2, 3],
        deliveryFee: 9,
        participants: [
          const BillParticipant(personId: 1, paidAmount: 49),
          const BillParticipant(personId: 2),
          const BillParticipant(personId: 3),
        ],
        items: [
          const BillItem(name: 'A', price: 30, assignedPersonIds: [1, 2]),
          const BillItem(name: 'B', price: 10, assignedPersonIds: [3]),
        ],
      ));

      expect(result.shareFor(1)!.owed, 18.0); // 15 items + 3 delivery
      expect(result.shareFor(2)!.owed, 18.0);
      expect(result.shareFor(3)!.owed, 13.0); // 10 items + 3 delivery
      expect(result.roundingDelta, closeTo(0.0, 0.0001)); // 40 + 9 = 49

      // Person 1 fronted 49; owes 18 → is repaid 31 by 2 (18) and 3 (13).
      final totalTransferred =
          result.transfers.fold<double>(0, (sum, t) => sum + t.amount);
      expect(totalTransferred, 31.0);
      expect(result.transfers.every((t) => t.toPersonId == 1), isTrue);
    });

    test('packaging + delivery fees combine into each person\'s owed', () {
      // A: 30 + pkg 3 = 33 → {1,2} = 16.5 each. B: 10 → {3}. Delivery 9 → +3 each.
      final result = _splitService.split(_detail(
        type: BillType.itemized,
        personIds: [1, 2, 3],
        deliveryFee: 9,
        items: [
          const BillItem(
              name: 'A', price: 30, packagingFee: 3, assignedPersonIds: [1, 2]),
          const BillItem(name: 'B', price: 10, assignedPersonIds: [3]),
        ],
      ));

      expect(result.shareFor(1)!.owed, 19.5); // 16.5 + 3
      expect(result.shareFor(2)!.owed, 19.5);
      expect(result.shareFor(3)!.owed, 13.0); // 10 + 3
      expect(result.roundingDelta, closeTo(0.0, 0.0001)); // 43 + 9 = 52
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
