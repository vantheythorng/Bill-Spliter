import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/service_locator.dart';
import 'core/localization/generated/app_localizations.dart';
import 'core/preferences/app_preferences.dart';
import 'core/routing/app_route_observer.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/bills/presentation/bills_screen.dart';
import 'features/onboarding/presentation/onboarding_controller.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/settings/domain/app_language.dart';
import 'features/settings/domain/supported_currencies.dart';
import 'features/settings/presentation/settings_provider.dart';
import 'shared/utils/currency_formatter.dart';

/// Root widget. Wires up the app-wide providers (settings, onboarding, a
/// fallback currency formatter) and the [MaterialApp] with theming,
/// localization and routing.
class BillSplitterApp extends StatelessWidget {
  const BillSplitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = getIt<AppPreferences>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(preferences)),
        ChangeNotifierProvider(
            create: (_) => OnboardingController(preferences)),
        // Fallback formatter for any amount shown without an explicit currency.
        // Every bill carries its own currency, so AmountText normally overrides
        // this; it exists only so `context.watch<CurrencyFormatter>()` resolves.
        Provider<CurrencyFormatter>(
          create: (_) => CurrencyFormatter(kDefaultCurrencyCode),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          // Use Kantumruy Pro as the primary font when Khmer is selected; other
          // languages keep the default font (with Kantumruy as a glyph fallback).
          final fontFamily = settings.language == AppLanguage.khmer
              ? AppTheme.khmerFontFamily
              : null;
          return MaterialApp(
            title: 'Bill Splitter',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(fontFamily: fontFamily),
            darkTheme: AppTheme.dark(fontFamily: fontFamily),
            themeMode: settings.themeMode,
            locale: settings.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLanguage.supportedLocales,
            onGenerateRoute: AppRouter.onGenerateRoute,
            navigatorObservers: [appRouteObserver],
            home: const _RootGate(),
          );
        },
      ),
    );
  }
}

/// Chooses between the onboarding storyboard and the home screen based on the
/// persisted onboarding flag.
class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final completed =
        context.watch<OnboardingController>().hasCompletedOnboarding;
    return completed ? const BillsScreen() : const OnboardingScreen();
  }
}
