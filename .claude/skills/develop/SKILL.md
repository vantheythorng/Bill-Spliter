---
name: develop
description: >-
  Develop the Bill Splitter Flutter app — use when implementing features, fixing bugs,
  editing screens/view models/models, changing the database, adding strings, or touching
  money/rounding/currency logic in this repo. Covers architecture, conventions, the
  localization workflow, and the required verify loop.
---

# Developing Bill Splitter

Offline-first bill-splitting app (Android/iOS). Flutter + Dart, Material 3, light/dark,
English + Khmer. No backend — SQLite (`sqflite`) + `SharedPreferences`. See `SPEC.md` for
the product spec.

**Toolchain:** Flutter 3.44 / Dart 3.12 on Windows. The shell is **PowerShell / Git Bash** —
use POSIX paths in the Bash tool. `flutter` and `dart` are on PATH.

## The dev loop (run before calling any change done)

```bash
flutter analyze          # must print "No issues found!"
flutter test             # unit + widget tests must pass
```

- After editing any **ARB** file (`lib/core/localization/l10n/*.arb`): run `flutter gen-l10n`
  before analyze, or the generated getters won't exist.
- To confirm an end-to-end Android compile (slower, first run installs NDK): `flutter build apk --debug`.
  APKs are renamed to `bill_splitter_<flavor|buildType>_<versionCode>_<versionName>.apk`
  by `android/app/build.gradle.kts`.

## Architecture (feature-first, layered MVVM)

```
lib/
  core/        di (get_it), database (sqflite schema + AppDatabase), theme, routing,
               localization (ARB + generated), preferences, constants
  shared/      models, utils (Money, CurrencyFormatter, RoundingMode, validators…),
               widgets (AmountText, PersonAvatar, ParticipantPicker, EmptyState…)
  features/    onboarding | people | bills | settings — each with data/ domain/ presentation/
```

Layering: **UI (Screen)** → **ViewModel (`ChangeNotifier`, via `ChangeNotifierProvider`)**
→ **Repository (abstract in `domain/`, impl in `data/`)** → **DAO / preferences** → **models**.
Calculation lives in pure services under `features/bills/domain/services/`
(`SplitService`, `SettleUpService`) — no Flutter imports, fully unit-tested.

**DI:** register singletons in `lib/core/di/service_locator.dart` (`getIt`). View models are
built per-screen in the screen's `ChangeNotifierProvider(create: ...)`, pulling deps from `getIt`.

## Conventions

**Adding a model** → `shared/models/`. Give it `toMap`/`fromMap` (keyed by `Db.*` constants
from `core/database/database_schema.dart`) and `copyWith`.

**Adding a screen + view model** → under the feature's `presentation/`. Screen is a
`StatelessWidget` wrapping `ChangeNotifierProvider(create: (_) => VM(getIt<...>()))` around an
inner view. Keep widgets dumb; logic in the view model. Add a route name to
`core/routing/route_names.dart` and a case in `core/routing/app_router.dart`.

**Localization** → add the key to **both** `app_en.arb` and `app_km.arb` (never leave Khmer
untranslated), then `flutter gen-l10n`. Access via `AppLocalizations.of(context)`. Avoid `$`
in ARB values — it becomes Dart string interpolation in the generated code.

**Money & rounding** → never do float division for shares. Convert to cents with
`Money.toCents`, distribute with `Money.distribute(totalCents, count, mode: rounding)`, convert
back with `Money.fromCents`. `RoundingMode` (`shared/utils/rounding_mode.dart`) is
`largestRemainder` (default) / `roundUp` / `roundDown`. The app uses **largestRemainder**
(fair pay): shares are floored and the leftover cent goes to one participant, so every split
sums to the exact total — one person (the payer, in settle-up) just pays a cent more, and
there is no extra/short/lost reconciliation indicator. `SplitService.split(detail, rounding:)`
returns a `Settlement` whose `roundingDelta` (Σ shares − true total) is always 0 under the
app's mode. The active mode comes from `SettingsProvider.roundingMode`, pushed into VMs via a
plain `rounding` setter during `build`.

**Currency is per bill**, not a setting. It's chosen in the create flow and stored on
`bill.currency_code`. Format amounts with `AmountText(amount, currencyCode: bill.currencyCode)`;
a `null` code falls back to the default `CurrencyFormatter` provider.

**Navigation** → create flow uses `pushReplacement` (Create → editor → detail); editing from
detail uses `push` then `pop` (editors branch on `BillEditorArgs.isNew`). The bills list is
`RouteAware` (via `appRouteObserver`) and refreshes in `didPopNext`.

**Database** → schema is defined once in `database_schema.dart` (`Db.*` + `createStatements`).
Writes to a bill aggregate go through `BillDao.save`, which replaces participants/items/
assignments/contributions in a single transaction. **Migration policy for this project:**
during development we do **not** write migrations — change the fresh-install DDL and reinstall
(DB version stays 1) unless told otherwise.

## Testing

- Unit tests in `test/unit/` (pure services + utils — highest value: `Money`, `SettleUpService`,
  `SplitService`, rounding). Widget tests in `test/widget/`.
- When you change split/settle/rounding behavior, add or update a `split_service_test` /
  `money_test` case that pins the exact expected shares (e.g. 100 ÷ 3).

## Definition of done

1. `flutter analyze` clean, `flutter test` green.
2. New user-facing strings exist in **both** ARBs and l10n is regenerated.
3. Behavior change to product source is verified — ideally exercised, at minimum covered by a test.
4. Match surrounding style; keep widgets dumb and logic in view models/services.
