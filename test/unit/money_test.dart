import 'package:bill_splitter/shared/utils/money.dart';
import 'package:bill_splitter/shared/utils/rounding_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money.distribute rounding modes', () {
    test('roundUp gives everyone the same rounded-up share', () {
      expect(
        Money.distribute(10000, 3, mode: RoundingMode.roundUp),
        [3334, 3334, 3334],
      );
    });

    test('roundDown gives everyone the same rounded-down share', () {
      expect(
        Money.distribute(10000, 3, mode: RoundingMode.roundDown),
        [3333, 3333, 3333],
      );
    });

    test('largestRemainder is the exact default', () {
      expect(Money.distribute(10000, 3), [3334, 3333, 3333]);
    });
  });

  group('Money.distribute', () {
    test('splits evenly when divisible', () {
      expect(Money.distribute(1000, 4), [250, 250, 250, 250]);
    });

    test('hands out remainder cents so the sum always matches the total', () {
      final shares = Money.distribute(1000, 3); // $10.00 / 3
      expect(shares, [334, 333, 333]);
      expect(shares.reduce((a, b) => a + b), 1000);
    });

    test('handles a total smaller than the number of people', () {
      final shares = Money.distribute(2, 5); // 2 cents among 5
      expect(shares.reduce((a, b) => a + b), 2);
      expect(shares.where((s) => s == 1).length, 2);
    });

    test('returns empty for zero recipients', () {
      expect(Money.distribute(1000, 0), isEmpty);
    });
  });

  group('Money conversion', () {
    test('rounds to nearest cent', () {
      expect(Money.toCents(12.34), 1234);
      expect(Money.toCents(2.999), 300);
      expect(Money.toCents(2.994), 299);
    });

    test('round-trips through cents', () {
      expect(Money.fromCents(Money.toCents(19.99)), 19.99);
    });
  });
}
