import 'package:bill_splitter/shared/models/person.dart';
import 'package:bill_splitter/shared/widgets/person_avatar.dart';
import 'package:bill_splitter/shared/utils/avatar_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PersonAvatar shows the person initials', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: PersonAvatar(
          person: Person(name: 'Ada Lovelace', colorSeed: 3),
        ),
      ),
    ));

    expect(find.text('AL'), findsOneWidget);
  });

  group('AvatarColor.initials', () {
    test('single name uses one letter', () {
      expect(AvatarColor.initials('Bob'), 'B');
    });

    test('multiple names use first and last initials', () {
      expect(AvatarColor.initials('Grace Brewster Hopper'), 'GH');
    });

    test('blank name falls back to a placeholder', () {
      expect(AvatarColor.initials('   '), '?');
    });
  });
}
