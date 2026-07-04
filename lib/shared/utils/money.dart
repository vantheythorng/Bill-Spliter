import 'rounding_mode.dart';

/// Monetary helpers. All splitting math is done in integer cents to avoid
/// floating-point drift, then converted back to double amounts at the edges.
class Money {
  const Money._();

  /// Converts a double amount to whole cents, rounding half-away-from-zero.
  static int toCents(double amount) => (amount * 100).round();

  /// Converts whole cents back to a double amount.
  static double fromCents(int cents) => cents / 100;

  /// Splits [totalCents] into [count] shares according to [mode].
  ///
  /// - [RoundingMode.largestRemainder] (default): every share gets the floor and
  ///   the leftover cents are handed to the first shares, so the shares always
  ///   sum back to [totalCents].
  /// - [RoundingMode.roundUp] / [RoundingMode.roundDown]: every share is the
  ///   same rounded value, so the sum may differ from [totalCents].
  static List<int> distribute(
    int totalCents,
    int count, {
    RoundingMode mode = RoundingMode.largestRemainder,
  }) {
    if (count <= 0) return const [];

    switch (mode) {
      case RoundingMode.roundUp:
        // Ceiling division (inputs here are non-negative amounts).
        final per = (totalCents + count - 1) ~/ count;
        return List<int>.filled(count, per);
      case RoundingMode.roundDown:
        return List<int>.filled(count, totalCents ~/ count);
      case RoundingMode.largestRemainder:
        final base = totalCents ~/ count;
        var remainder = totalCents - base * count;
        final shares = List<int>.filled(count, base);
        // Hand out remaining cents deterministically to the leading shares.
        // `remainder` can be negative when splitting a negative total.
        final step = remainder >= 0 ? 1 : -1;
        var i = 0;
        while (remainder != 0) {
          shares[i % count] += step;
          remainder -= step;
          i++;
        }
        return shares;
    }
  }

  /// Distributes [total] across [count] recipients and returns the shares as
  /// double amounts.
  static List<double> distributeAmount(
    double total,
    int count, {
    RoundingMode mode = RoundingMode.largestRemainder,
  }) {
    return distribute(toCents(total), count, mode: mode)
        .map(fromCents)
        .toList();
  }
}
