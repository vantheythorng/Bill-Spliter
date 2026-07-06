import 'package:bill_splitter/shared/models/person.dart';
import 'package:bill_splitter/shared/widgets/app_text_field.dart';
import 'package:bill_splitter/shared/widgets/muted_text.dart';
import 'package:bill_splitter/shared/widgets/person_amount_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: child));

void main() {
  group('AppTextField', () {
    testWidgets('renders label and reports changes', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AppTextField(
        label: 'Title',
        onChanged: (v) => changed = v,
      )));

      expect(find.text('Title'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Dinner');
      expect(changed, 'Dinner');
    });

    testWidgets('.amount uses a decimal numeric keyboard', (tester) async {
      await tester.pumpWidget(_wrap(const AppTextField.amount(label: 'Amount')));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.keyboardType, const TextInputType.numberWithOptions(decimal: true));
    });
  });

  group('PersonAmountTile', () {
    testWidgets('shows the person name and an amount', (tester) async {
      await tester.pumpWidget(_wrap(const PersonAmountTile(
        person: Person(id: 1, name: 'Ada', colorSeed: 0),
        amount: 12.5,
        currencyCode: 'USD',
      )));

      expect(find.text('Ada'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('falls back to a placeholder when person is null', (tester) async {
      await tester.pumpWidget(_wrap(const PersonAmountTile(
        person: null,
        amount: 0,
        currencyCode: 'USD',
      )));

      expect(find.text('—'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('shows a delete button only when onDelete is given',
        (tester) async {
      var deleted = false;
      await tester.pumpWidget(_wrap(PersonAmountTile(
        person: const Person(id: 1, name: 'Ada', colorSeed: 0),
        amount: 5,
        currencyCode: 'USD',
        onDelete: () => deleted = true,
      )));

      await tester.tap(find.byIcon(Icons.delete_outline));
      expect(deleted, isTrue);
    });

    testWidgets('card:false renders no Card', (tester) async {
      await tester.pumpWidget(_wrap(const PersonAmountTile(
        person: Person(id: 1, name: 'Ada', colorSeed: 0),
        amount: 5,
        currencyCode: 'USD',
        card: false,
      )));

      expect(find.byType(Card), findsNothing);
    });
  });

  testWidgets('MutedText renders its text', (tester) async {
    await tester.pumpWidget(_wrap(const MutedText('hello')));
    expect(find.text('hello'), findsOneWidget);
  });
}
