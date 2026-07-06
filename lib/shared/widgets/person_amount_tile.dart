import 'package:flutter/material.dart';

import '../models/person.dart';
import 'amount_text.dart';
import 'person_avatar.dart';

/// A person row with a trailing money amount — the recurring list item used in
/// the editors' breakdowns and contribution lists. Shows a [PersonAvatar]
/// (falling back to a generic person icon when [person] is null, e.g. a deleted
/// person), the person's name, an optional [subtitle], and the [amount] on the
/// trailing edge. Pass [onDelete] to add a delete button; set [card] to false
/// to render a bare [ListTile] instead of a [Card]-wrapped one.
class PersonAmountTile extends StatelessWidget {
  const PersonAmountTile({
    super.key,
    required this.person,
    required this.amount,
    this.currencyCode,
    this.subtitle,
    this.amountStyle,
    this.amountColor,
    this.onDelete,
    this.avatarRadius = 20,
    this.card = true,
  });

  final Person? person;
  final double amount;
  final String? currencyCode;
  final String? subtitle;
  final TextStyle? amountStyle;
  final Color? amountColor;
  final VoidCallback? onDelete;
  final double avatarRadius;
  final bool card;

  @override
  Widget build(BuildContext context) {
    final amountText = AmountText(
      amount,
      currencyCode: currencyCode,
      style: amountStyle,
      color: amountColor,
    );

    final tile = ListTile(
      leading: person == null
          ? CircleAvatar(
              radius: avatarRadius, child: const Icon(Icons.person))
          : PersonAvatar(person: person!, radius: avatarRadius),
      title: Text(person?.name ?? '—'),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: onDelete == null
          ? amountText
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                amountText,
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                ),
              ],
            ),
    );

    return card ? Card(child: tile) : tile;
  }
}
