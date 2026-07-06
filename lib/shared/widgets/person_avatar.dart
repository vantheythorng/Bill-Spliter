import 'package:flutter/material.dart';

import '../models/person.dart';
import '../utils/avatar_color.dart';

/// A circular avatar showing a person's first initial + id on a stable, seeded
/// color.
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
      // Labels vary in length (e.g. "A" vs "A12"), so scale the text to fit
      // inside the circle instead of using a fixed font size.
      child: Padding(
        padding: EdgeInsets.all(radius * 0.22),
        child: FittedBox(
          child: Text(
            AvatarColor.label(person.name, person.id),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
