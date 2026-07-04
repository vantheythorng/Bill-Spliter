import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/route_names.dart';
import '../../../shared/utils/rounding_mode.dart';
import '../../../shared/widgets/section_header.dart';
import '../domain/app_language.dart';
import 'settings_provider.dart';

/// Settings: theme, language, currency, people management and about.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _themeLabel(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.system:
        return l10n.themeSystem;
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
    }
  }

  String _roundingTitle(RoundingMode mode, AppLocalizations l10n) {
    switch (mode) {
      case RoundingMode.roundUp:
        return l10n.roundingUpTitle;
      case RoundingMode.roundDown:
        return l10n.roundingDownTitle;
      case RoundingMode.largestRemainder:
        return l10n.roundingExactTitle;
    }
  }

  String _roundingDetail(RoundingMode mode, AppLocalizations l10n) {
    switch (mode) {
      case RoundingMode.roundUp:
        return l10n.roundingUpDetail;
      case RoundingMode.roundDown:
        return l10n.roundingDownDetail;
      case RoundingMode.largestRemainder:
        return l10n.roundingExactDetail;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(title: l10n.settingsAppearance),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: Text(l10n.settingsTheme),
                  trailing: DropdownButton<ThemeMode>(
                    value: settings.themeMode,
                    underline: const SizedBox.shrink(),
                    onChanged: (mode) {
                      if (mode != null) settings.setThemeMode(mode);
                    },
                    items: [
                      for (final mode in ThemeMode.values)
                        DropdownMenuItem(
                          value: mode,
                          child: Text(_themeLabel(mode, l10n)),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(l10n.settingsLanguage),
                  trailing: DropdownButton<AppLanguage>(
                    value: settings.language,
                    underline: const SizedBox.shrink(),
                    onChanged: (language) {
                      if (language != null) settings.setLanguage(language);
                    },
                    items: [
                      for (final language in AppLanguage.values)
                        DropdownMenuItem(
                          value: language,
                          child: Text(language.displayName),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader(title: l10n.settingsRounding),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              l10n.settingsRoundingHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Card(
            child: RadioGroup<RoundingMode>(
              groupValue: settings.roundingMode,
              onChanged: (mode) {
                if (mode != null) settings.setRoundingMode(mode);
              },
              child: Column(
                children: [
                  for (final mode in RoundingMode.values)
                    RadioListTile<RoundingMode>(
                      value: mode,
                      title: Text(_roundingTitle(mode, l10n)),
                      subtitle: Text(_roundingDetail(mode, l10n)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader(title: l10n.peopleTitle),
          Card(
            child: ListTile(
              leading: const Icon(Icons.group_outlined),
              title: Text(l10n.settingsPeople),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteNames.people),
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader(title: l10n.settingsAbout),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.settingsVersion),
              trailing: Text(AppConstants.appVersion),
            ),
          ),
        ],
      ),
    );
  }
}
