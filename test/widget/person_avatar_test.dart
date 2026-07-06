import 'package:bill_splitter/shared/models/person.dart';
import 'package:bill_splitter/shared/widgets/person_avatar.dart';
import 'package:bill_splitter/shared/utils/avatar_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PersonAvatar shows first initial + id', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: PersonAvatar(
          person: Person(id: 3, name: 'Ada Lovelace', colorSeed: 3),
        ),
      ),
    ));

    expect(find.text('A3'), findsOneWidget);
  });

  group('AvatarColor.label', () {
    test('first letter + id keeps same-initial people distinct', () {
      expect(AvatarColor.label('Bob', 7), 'B7');
      expect(AvatarColor.label('Ada Lovelace', 3), 'A3');
    });

    test('null id (unsaved person) is just the letter', () {
      expect(AvatarColor.label('Bob', null), 'B');
    });

    test('blank name falls back to a placeholder', () {
      expect(AvatarColor.label('   ', 5), '?5');
      expect(AvatarColor.label('   ', null), '?');
    });
  });
}
