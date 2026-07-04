import '../../core/database/database_schema.dart';

/// A reusable person that can participate in many bills.
class Person {
  const Person({
    this.id,
    required this.name,
    required this.colorSeed,
    this.createdAt,
  });

  final int? id;
  final String name;

  /// Stable seed used to derive this person's avatar color.
  final int colorSeed;
  final DateTime? createdAt;

  Person copyWith({int? id, String? name, int? colorSeed, DateTime? createdAt}) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      colorSeed: colorSeed ?? this.colorSeed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) Db.personId: id,
      Db.personName: name,
      Db.personColorSeed: colorSeed,
      Db.personCreatedAt:
          (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
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
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Person && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
