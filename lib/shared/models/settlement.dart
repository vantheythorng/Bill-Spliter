/// A single "X pays Y amount" transfer produced by the settle-up algorithm.
class Transfer {
  const Transfer({
    required this.fromPersonId,
    required this.toPersonId,
    required this.amount,
  });

  final int fromPersonId;
  final int toPersonId;
  final double amount;
}

/// Per-person outcome for a bill: what they owed, what they paid and the
/// resulting balance.
class PersonShare {
  const PersonShare({
    required this.personId,
    required this.owed,
    required this.paid,
  });

  final int personId;
  final double owed;
  final double paid;

  /// Positive → the person is owed money back. Negative → the person owes.
  double get balance => paid - owed;
}

/// The complete result of splitting a bill: each person's share plus the
/// minimal set of transfers to settle up.
class Settlement {
  const Settlement({
    required this.shares,
    this.transfers = const [],
    this.roundingDelta = 0,
  });

  final List<PersonShare> shares;
  final List<Transfer> transfers;

  /// Sum of the per-person shares minus the true bill total. With rounding
  /// enabled this can be non-zero:
  /// - positive → shares collect **more** than the total (extra);
  /// - negative → shares collect **less** than the total (short);
  /// - zero → the split adds up exactly.
  final double roundingDelta;

  PersonShare? shareFor(int personId) {
    for (final share in shares) {
      if (share.personId == personId) return share;
    }
    return null;
  }
}
