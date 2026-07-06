import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../shared/widgets/app_text_field.dart';

/// A dialog for adding or renaming a person. Returns the entered name, or null
/// if cancelled.
class PersonFormDialog extends StatefulWidget {
  const PersonFormDialog({super.key, this.initialName});

  final String? initialName;

  static Future<String?> show(BuildContext context, {String? initialName}) {
    return showDialog<String>(
      context: context,
      builder: (_) => PersonFormDialog(initialName: initialName),
    );
  }

  @override
  State<PersonFormDialog> createState() => _PersonFormDialogState();
}

class _PersonFormDialogState extends State<PersonFormDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.initialName != null;
    return AlertDialog(
      title: Text(isEditing ? l10n.editPerson : l10n.addPerson),
      content: Form(
        key: _formKey,
        child: AppTextField(
          controller: _controller,
          autofocus: true,
          label: l10n.personNameLabel,
          textCapitalization: TextCapitalization.words,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? l10n.validationRequired
              : null,
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.save)),
      ],
    );
  }
}
