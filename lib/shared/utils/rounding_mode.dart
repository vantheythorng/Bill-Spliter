/// How per-person shares are rounded when a total does not divide evenly.
///
/// [largestRemainder] is the app-wide default (fair pay, exact reconciliation).
///
/// - [largestRemainder]: every share gets the floor and the leftover cents are
///   handed to the first shares, so the shares always sum back to the total
///   (100 / 3 → 33.34, 33.33, 33.33). One participant simply pays a cent more.
/// - [roundUp]: every share is rounded up to the cent, so everyone pays the
///   same amount and the collected total may slightly exceed the bill
///   (100 / 3 → 33.34, 33.34, 33.34).
/// - [roundDown]: every share is rounded down to the cent, so everyone pays the
///   same amount and the collected total may fall slightly short
///   (100 / 3 → 33.33, 33.33, 33.33).
enum RoundingMode {
  roundUp('round_up'),
  roundDown('round_down'),
  largestRemainder('largest_remainder');

  const RoundingMode(this.storageValue);

  /// Value persisted in preferences.
  final String storageValue;

  /// The default when nothing has been chosen yet.
  static const RoundingMode defaultMode = RoundingMode.largestRemainder;

  static RoundingMode fromStorage(String? value) {
    return RoundingMode.values.firstWhere(
      (mode) => mode.storageValue == value,
      orElse: () => defaultMode,
    );
  }
}
