import '../../core/database/database_schema.dart';

/// A reusable person that can participate in many bills.
class Person {
  const Person({
    this.id,
    required this.name,
    required this.colorSeed,
    this.createdAt,
    this.active = true,
  });

  final int? id;
  final String name;

  /// Stable seed used to derive this person's avatar color.
  final int colorSeed;
  final DateTime? createdAt;

  /// Whether this person appears in the participant picker when creating a
  /// bill. Deactivated people are hidden from selection but kept for the
  /// history of any bill they already belong to.
  final bool active;

  Person copyWith({
    int? id,
    String? name,
    int? colorSeed,
    DateTime? createdAt,
    bool? active,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      colorSeed: colorSeed ?? this.colorSeed,
      createdAt: createdAt ?? this.createdAt,
      active: active ?? this.active,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) Db.personId: id,
      Db.personName: name,
      Db.personColorSeed: colorSeed,
      Db.personCreatedAt:
          (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
      Db.personActive: active ? 1 : 0,
    };
  }

  factory Person.fromMap(Map<String, Object?> map) {
    return Person(
      id: map[Db.personId] as int?,
      name: map[Db.personName] as String,
      colorSeed: (map[Db.personColorSeed] as int?) ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map[Db.personCreatedAt] as int?) ?? 0,
      ),
      active: ((map[Db.personActive] as int?) ?? 1) == 1,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Person && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
