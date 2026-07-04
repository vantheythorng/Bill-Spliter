import 'bill.dart';
import 'bill_item.dart';
import 'bill_participant.dart';
import 'party_contribution.dart';
import 'person.dart';

/// A fully-loaded bill: the [Bill] row plus its participants, items and
/// contributions, joined against the [Person] list for display. This is the
/// aggregate the editors and detail screen operate on.
class BillDetail {
  const BillDetail({
    required this.bill,
    this.participants = const [],
    this.people = const [],
    this.items = const [],
    this.contributions = const [],
  });

  final Bill bill;
  final List<BillParticipant> participants;

  /// The [Person] records for every participant, in the same conceptual set.
  final List<Person> people;
  final List<BillItem> items;
  final List<PartyContribution> contributions;

  Person? personById(int id) {
    for (final person in people) {
      if (person.id == id) return person;
    }
    return null;
  }

  List<int> get participantPersonIds =>
      participants.map((p) => p.personId).toList();

  BillDetail copyWith({
    Bill? bill,
    List<BillParticipant>? participants,
    List<Person>? people,
    List<BillItem>? items,
    List<PartyContribution>? contributions,
  }) {
    return BillDetail(
      bill: bill ?? this.bill,
      participants: participants ?? this.participants,
      people: people ?? this.people,
      items: items ?? this.items,
      contributions: contributions ?? this.contributions,
    );
  }
}
