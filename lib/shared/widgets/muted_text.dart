import 'package:flutter/material.dart';

/// Secondary/caption text in the muted `onSurfaceVariant` colour. Defaults to
/// the `bodyMedium` size; pass [style] for a different base size (e.g.
/// `bodyLarge`) and the muted colour is still applied on top.
class MutedText extends StatelessWidget {
  const MutedText(this.text, {super.key, this.style, this.textAlign});

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      textAlign: textAlign,
      style: (style ?? theme.textTheme.bodyMedium)?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
