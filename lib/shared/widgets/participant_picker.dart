import 'package:flutter/material.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../models/person.dart';
import 'person_avatar.dart';

/// A reusable participant selector: lists every saved [Person] as a toggleable
/// chip and offers an inline quick-add field so a new person can be created
/// without leaving the flow. The widget is dumb — selection state and the
/// quick-add action are owned by the parent.
class ParticipantPicker extends StatefulWidget {
  const ParticipantPicker({
    super.key,
    required this.people,
    required this.selectedPersonIds,
    required this.onToggle,
    required this.onQuickAdd,
  });

  final List<Person> people;
  final Set<int> selectedPersonIds;
  final ValueChanged<int> onToggle;

  /// Called with the trimmed name to create-and-select a new person.
  final ValueChanged<String> onQuickAdd;

  @override
  State<ParticipantPicker> createState() => _ParticipantPickerState();
}

class _ParticipantPickerState extends State<ParticipantPicker> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitQuickAdd() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    widget.onQuickAdd(name);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.people.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final person in widget.people)
                _PersonChip(
                  person: person,
                  selected: person.id != null &&
                      widget.selectedPersonIds.contains(person.id),
                  onSelected: () {
                    if (person.id != null) widget.onToggle(person.id!);
                  },
                ),
            ],
          ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: l10n.addParticipantHint,
            prefixIcon: const Icon(Icons.person_add_alt),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _submitQuickAdd,
            ),
          ),
          onSubmitted: (_) => _submitQuickAdd(),
        ),
      ],
    );
  }
}

class _PersonChip extends StatelessWidget {
  const _PersonChip({
    required this.person,
    required this.selected,
    required this.onSelected,
  });

  final Person person;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      avatar: PersonAvatar(person: person, radius: 12),
      label: Text(person.name),
      showCheckmark: false,
    );
  }
}
