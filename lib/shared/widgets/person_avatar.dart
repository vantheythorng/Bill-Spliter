import 'package:flutter/material.dart';

import '../models/person.dart';
import '../utils/avatar_color.dart';

/// A circular avatar showing a person's initials on a stable, seeded color.
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({super.key, required this.person, this.radius = 20});

  final Person person;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = AvatarColor.forSeed(person.colorSeed, scheme);

    return CircleAvatar(
      radius: radius,
      backgroundColor: background,
      child: Text(
        AvatarColor.initials(person.name),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
