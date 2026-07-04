import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../shared/models/person.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/person_avatar.dart';
import '../domain/person_repository.dart';
import 'people_view_model.dart';
import 'widgets/person_form_dialog.dart';

/// Screen for managing the reusable list of people.
class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PeopleViewModel(getIt<PersonRepository>())..load(),
      child: const _PeopleView(),
    );
  }
}

class _PeopleView extends StatelessWidget {
  const _PeopleView();

  Future<void> _addPerson(BuildContext context) async {
    final name = await PersonFormDialog.show(context);
    if (name != null && context.mounted) {
      await context.read<PeopleViewModel>().addPerson(name);
    }
  }

  Future<void> _editPerson(BuildContext context, Person person) async {
    final name =
        await PersonFormDialog.show(context, initialName: person.name);
    if (name != null && context.mounted) {
      await context.read<PeopleViewModel>().renamePerson(person, name);
    }
  }

  Future<void> _deletePerson(BuildContext context, Person person) async {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<PeopleViewModel>();
    final referenced = await viewModel.isReferenced(person);
    if (!context.mounted) return;

    if (referenced) {
      final confirmed = await ConfirmDialog.show(
        context,
        title: l10n.deletePersonTitle(person.name),
        message: l10n.deletePersonBody,
        confirmLabel: l10n.delete,
        destructive: true,
      );
      if (!confirmed) return;
    }
    await viewModel.deletePerson(person);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<PeopleViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.peopleTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addPerson(context),
        icon: const Icon(Icons.person_add),
        label: Text(l10n.addPerson),
      ),
      body: viewModel.loading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.isEmpty
              ? EmptyState(
                  icon: Icons.group_outlined,
                  title: l10n.peopleEmptyTitle,
                  message: l10n.peopleEmptyBody,
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: viewModel.people.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final person = viewModel.people[index];
                    return ListTile(
                      leading: PersonAvatar(person: person),
                      title: Text(person.name),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editPerson(context, person);
                          } else if (value == 'delete') {
                            _deletePerson(context, person);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                          PopupMenuItem(
                              value: 'delete', child: Text(l10n.delete)),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
