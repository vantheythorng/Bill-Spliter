# Bill Splitter — Project Specification

A modern, cross-platform mobile application built with **Flutter** for splitting bills
among people, either equally or by itemized consumption with settle-up.

> **Offline-first, local-only.** All data lives on the device (SQLite + SharedPreferences).
> There is no backend, no accounts, and no network dependency — the app is fully functional
> without connectivity.

---

## 1. Overview

| Item | Value |
|------|-------|
| **Name** | Bill Splitter (working title) |
| **Framework** | Flutter (stable channel), Dart |
| **Platforms** | Android & iOS |
| **State management** | `provider` |
| **Dependency injection** | `get_it` (service locator) + `provider` for view-model injection |
| **Local persistence** | SQLite via `sqflite` |
| **Theming** | Material 3, full light & dark mode support |
| **Localization** | English and Khmer (`km`), with `intl` + ARB; Khmer renders with the bundled **Kantumruy Pro** font |
| **Currency** | Per-bill (chosen at creation); no app-wide currency setting |
| **Rounding** | User-selectable split rounding (Round up default / Round down / Exact) |

### Design principles (from constraints)
- Follow official Flutter conventions and idiomatic Dart.
- Clean, layered architecture with clear separation of concerns.
- Reusable widgets and shared utilities — no copy-paste UI or logic.
- Readable, self-documenting code.
- Features organized by name (feature-first folder structure).

---

## 2. Confirmed Decisions

These were clarified with the user and are binding for implementation:

1. **Split logic — Itemized + settle-up.** Each item on a bill is assigned to the
   people who consumed it and split among them. The app computes each person's total
   share, then nets balances to show **who owes whom** the minimum number of transfers.
   Equal split (Feature 1) is a special case where every item/total is shared by everyone.
   **Party split (Feature 3.4)** is a third mode: multiple people front cash for various
   things, the grand total is split equally, and settle-up reimburses overspenders.
2. **Data model — Reusable people + bills.** A persistent list of people is maintained.
   Each bill references participants drawn from that list, enabling per-person history.
   **Inline quick-add:** people can be created directly from the bill's participant
   picker (type a name → add) without visiting the People screen first. A quick-added
   person is saved to the reusable list automatically, so pre-creation is optional, never
   required. The People screen remains for managing/editing saved people, and for
   deactivating (or reactivating) them — see §5 for the delete-vs-deactivate rule.
3. **Localization — English and Khmer.** Both ship at launch; the i18n infrastructure
   (ARB files, `flutter_localizations`, generated `AppLocalizations`) makes adding more
   languages a matter of a new ARB. Khmer glyphs render with the bundled **Kantumruy Pro**
   font (OFL), applied as the primary font when Khmer is selected and as a glyph fallback
   otherwise.
4. **Currency — per bill.** Each bill records its own currency, chosen in the create flow
   (a supported-currency picker, defaulting to USD). Amounts are formatted per bill, so
   different bills can use different currencies. There is **no** app-wide currency setting
   and no multi-currency conversion within a bill.
5. **Split rounding — user-selectable.** A Settings option controls how uneven splits
   round: **Round up** (default — everyone pays the same, rounded up), **Round down**, or
   **Exact** (largest-remainder; shares sum exactly to the total). Result screens surface
   whether the chosen mode collects an **Extra** amount, comes up **Short**, or **adds up
   exactly**.

---

## 3. Features

### 3.1 Onboarding Storyboard (first launch)
- A swipeable, multi-page carousel shown only on the **first** app launch.
- Introduces core value props (equal split, itemized split, settle-up, history).
- "Skip" and "Get Started" actions; final page enters the app.
- A `hasCompletedOnboarding` flag is persisted (SharedPreferences) so it never shows again.

### 3.2 Equal Split
- Create a bill, pick participants, enter a total amount.
- App divides the total equally according to the selected **rounding mode** (§3.6):
  Exact uses the largest-remainder method so shares always sum to the total; Round
  up/down give every person the same rounded share.

### 3.3 Itemized Split + Settle-Up
- Add line items to a bill (name, price, quantity).
- Assign each item to one or more participants; the item cost splits equally among them.
- Optionally add shared charges (tax, tip, service) split across all or selected people.
- App computes each person's total owed and each person's actual payments, then runs a
  **settle-up algorithm** to produce the minimal set of "X pays Y amount" transactions.

### 3.4 Party / Shared-Pot Split
For group events (parties, trips) where **multiple people each pay for different things
out of their own money**, and the **grand total is shared equally** by everyone —
regardless of who bought what.

- Add each contribution: who paid and how much (e.g. "Alice paid 300 for drinks",
  "Bob paid 120 for snacks"). One person can log several contributions.
- App sums all contributions into a grand total and divides it equally:
  `equalShare = grandTotal / numberOfPeople`.
- For each person it computes `balance = amountPaid − equalShare`:
  - **Positive** → the person overspent and **gets money back**.
  - **Negative** → the person underspent and **owes** the difference.
- Reuses the existing settle-up algorithm to produce the minimal set of transfers so
  everyone ends up having effectively paid the same equal share.

> Difference from Itemized (3.3): in Itemized, each item is consumed/owed by specific
> people. In Party, **no item is assigned to anyone** — the entire pot is split equally;
> contributions only track who fronted the cash.

### 3.5 Settings
- **Theme:** System / Light / Dark.
- **Language:** English and Khmer (ខ្មែរ); ARB scaffold ready for more.
- **Split rounding:** Round up (default) / Round down / Exact (see §3.6).
- **Manage people:** add / edit saved people; delete those with no bill history, or
  deactivate / reactivate those that do (§5).
- App version / about.

> Currency is **not** a setting — it is chosen per bill in the create flow (§3.7).

### 3.6 Split Rounding
- A single app-wide setting chooses how per-person shares round when a bill does not
  divide evenly:
  - **Round up** *(default)* — everyone pays the same amount, rounded up (collected total
    may slightly exceed the bill).
  - **Round down** — everyone pays the same amount, rounded down (may fall short).
  - **Exact** — largest-remainder distribution; shares always sum to the total, cents may
    differ by one between people.
- Applies to equal, itemized and party splits alike (all reduce to distributing cents).
- The result and editor screens show a **reconciliation indicator** — *Extra collected*,
  *Short of total*, or *Adds up exactly* — with the difference amount.

### 3.7 Per-Bill Currency
- The currency is selected **when creating a bill** (a picker over a supported-currency
  list, defaulting to USD) and stored on the bill record.
- Every amount for that bill — list, detail, editors, settle-up — is formatted in its own
  currency, so a session can hold bills in different currencies. No conversion is performed.

---

## 4. Architecture

Layered, MVVM-flavored architecture. The non-UI layers are centralized under `core/`, each in
its own folder grouped by feature — `core/dao/<feature>` (SQLite DAOs), `core/repository/<feature>`
(repository interface **and** its implementation together), and `core/services/<feature>` (pure
calculation services). Shared value types live with their kind — enums in `shared/utils`,
constant reference data in `core/constants`. The **presentation** layer stays feature-first
under `features/<feature>/presentation`:

```
UI (Widgets/Screens)
   └─ ViewModel (ChangeNotifier, provided via Provider)
        └─ Repository (interface)
             └─ Data source (SQLite DAO / SharedPreferences)
                  └─ Models
```

- **Presentation layer:** `Screen` widgets + `ChangeNotifier` view models exposed through
  `ChangeNotifierProvider`. Widgets are dumb; logic lives in view models.
- **Repository layer:** each repository's abstract interface and its implementation live
  together in `core/repository/<feature>`; the impl delegates to a DAO.
- **Services layer:** pure calculation services (split & settle-up logic) in
  `core/services/` — fully unit-testable, no Flutter dependencies.
- **Data layer:** `sqflite` database + `BaseDao`, DAOs in `core/dao/<feature>`, and a
  `SharedPreferences` wrapper.
- **DI:** `get_it` registers repositories, services, and the database as singletons at
  startup; view models receive their dependencies via constructor injection.

---

## 5. Folder Structure (layered core + feature-first UI)

```
lib/
├── main.dart                     # bootstrap: DI init, runApp
├── app.dart                      # MaterialApp, theme, localization, routing
│
├── core/
│   ├── di/                       # get_it service locator setup
│   ├── database/                 # sqflite init, schema, BaseDao
│   ├── dao/                      # SQLite DAOs, grouped by feature
│   │   ├── people/               #   person_dao
│   │   └── bills/                #   bill_dao
│   ├── repository/               # repo interface + impl together, by feature
│   │   ├── people/               #   person_repository (+ _impl)
│   │   └── bills/                #   bill_repository (+ _impl)
│   ├── services/                 # pure calculation services
│   │   └── bills/                #   split + settle-up services
│   ├── theme/                    # light & dark ThemeData, colors, text styles
│   ├── routing/                  # route names & generator
│   ├── localization/             # AppLocalizations, ARB files (l10n)
│   └── constants/                # app constants + supported_currencies (const data)
│
├── shared/
│   ├── widgets/                  # reusable widgets (avatars, amount/muted text,
│   │                             #   app text field, person-amount tile, empty
│   │                             #   states, dialogs, participant picker)
│   ├── utils/                    # money, currency/date formatters, validators,
│   │                             #   rounding_mode + app_language enums
│   └── models/                   # shared models used across features
│
└── features/                     # presentation only — UI grouped by feature
    ├── onboarding/presentation/
    ├── people/presentation/      # people list, person profile (bill history)
    ├── bills/presentation/       # create/list/detail bills, equal/itemized/party
    └── settings/presentation/    # theme, language, currency, people entry

test/
├── unit/                         # services, view models, utils
└── widget/                       # reusable widgets & screens
```

---

## 6. Data Model (SQLite)

```
person
  id            INTEGER PK
  name          TEXT NOT NULL
  color_seed    INTEGER            -- for avatar color
  created_at    INTEGER
  active        INTEGER DEFAULT 1  -- 0 = deactivated: hidden from the participant picker

bill
  id            INTEGER PK
  title         TEXT NOT NULL
  type          TEXT NOT NULL      -- 'equal' | 'itemized' | 'party'
  total_amount  REAL               -- equal: entered directly; party: derived = SUM(paid_amount)
  currency_code TEXT               -- per-bill currency (chosen at creation)
  created_at    INTEGER
  updated_at    INTEGER

bill_participant                   -- many-to-many bill <-> person
  id            INTEGER PK
  bill_id       INTEGER FK -> bill(id) ON DELETE CASCADE
  person_id     INTEGER FK -> person(id)
  paid_amount   REAL DEFAULT 0     -- what this person actually paid (itemized & party).
                                   --   In party mode, sum of a person's contributions.

bill_item                          -- itemized bills only
  id            INTEGER PK
  bill_id       INTEGER FK -> bill(id) ON DELETE CASCADE
  name          TEXT NOT NULL
  price         REAL NOT NULL
  quantity      INTEGER DEFAULT 1

bill_item_assignment               -- which people share an item (itemized only)
  id            INTEGER PK
  bill_item_id  INTEGER FK -> bill_item(id) ON DELETE CASCADE
  person_id     INTEGER FK -> person(id)

party_contribution                 -- party mode: each thing a person paid for
  id            INTEGER PK
  bill_id       INTEGER FK -> bill(id) ON DELETE CASCADE
  person_id     INTEGER FK -> person(id)
  label         TEXT               -- e.g. 'drinks', 'snacks' (optional)
  amount        REAL NOT NULL
```

> For party bills, `bill_participant.paid_amount` is the cached SUM of that person's
> `party_contribution.amount` rows (kept for fast balance math).

- Deleting a person is guarded by their bill history:
  - **No records** → the person can be deleted outright (confirm-before-delete).
  - **Referenced by any bill** (participant, item assignment, or contribution) → delete is
    blocked; instead the person is **deactivated** (`active = 0`), which hides them from the
    participant picker while preserving all history. Deactivation is reversible (reactivate).
    An already-selected but since-deactivated participant stays visible on that existing bill.
- Non-relational preferences (theme, language, split-rounding mode, onboarding flag) live
  in **SharedPreferences**, not SQLite. Currency is per bill and lives on the `bill` row.

---

## 7. Screens

1. **Onboarding** — first-launch storyboard carousel.
2. **Home / Bills list** — list of saved bills with totals; FAB to create a new bill.
3. **Create Bill** — title, type (equal / itemized / party), **currency picker**, and a
   participant picker. The picker lists saved people **and** has a quick-add field to create
   a new person inline (auto-saved to the reusable list) without leaving the flow.
   - **Editing:** the type-specific editors (4–6) also let the user change the **title** and
     **add/remove participants** (with the same inline quick-add), not just amounts/items —
     removing a participant prunes their item assignments and party contributions.
4. **Equal Split editor** — total amount, live per-person share preview.
5. **Itemized editor** — item list, per-item people assignment, shared charges.
6. **Party editor** — add contributions (who paid, amount, optional label); live grand
   total, equal share, and per-person balance (get back / owe) preview.
7. **Bill Detail / Result** — per-person breakdown + settle-up ("who pays whom"). Opened
   editable from the bills list (edit/delete actions), or **read-only** from a person profile
   (§8, actions hidden).
8. **People** — manage the reusable person list. Tapping a person opens their **profile**.
   - **Person profile** — the person's identity plus their **bill history**: every bill they
     appear in (participant, item, or contribution), most-recent first. Tapping a bill opens
     it in the read-only Bill Detail (screen 7).
9. **Settings** — theme, language, currency, people, about.

---

## 8. Key Technical Details

- **Currency formatting:** centralized `CurrencyFormatter` util using `intl`'s
  `NumberFormat.simpleCurrency`, driven by **each bill's own currency** (`AmountText`
  accepts a per-bill currency code; a default formatter is provided as a fallback).
- **Rounding:** all monetary math is done in **integer cents** to avoid floating-point
  drift (`Money.distribute`). The distribution honours the selected `RoundingMode`
  (largest-remainder / round-up / round-down). The split result carries a `roundingDelta`
  (Σ shares − true total) that drives the Extra / Short / Exact indicator.
- **Settle-up algorithm:** greedy min-transactions — repeatedly match the largest
  creditor with the largest debtor until all balances are zero. Shared by itemized and
  party modes: balances come from `paid − owedShare` in both cases.
- **Party balance math:** `equalShare = SUM(contributions) / people`; each person's
  `balance = theirContributions − equalShare` (positive = reimbursed, negative = owes).
- **Theming:** single source of truth for `ColorScheme` seeds; light/dark derived from
  Material 3 `ColorScheme.fromSeed`. Theme mode reactive via a `ThemeProvider`.
- **Reactivity:** settings changes (theme, language, rounding mode) propagate immediately
  via `provider` listeners. Per-bill currency is threaded through the widgets that render
  amounts.

---

## 9. Proposed Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `get_it` | Dependency injection / service locator |
| `sqflite` | SQLite local database |
| `path` / `path_provider` | Resolve DB file location |
| `shared_preferences` | Key-value preferences (theme, language, currency, onboarding) |
| `intl` | Localization & currency/number/date formatting |
| `flutter_localizations` (SDK) | Localization delegates |
| `uuid` *(optional)* | IDs if not using autoincrement |

**Bundled assets:** `assets/fonts/KantumruyPro-Variable.ttf` (Google Fonts, OFL) —
registered as family `Kantumruy Pro` for Khmer text.

**Build:** built APKs are renamed to `bill_splitter_<flavor|buildType>_<versionCode>_<versionName>.apk`
via the app-level Gradle config. Android launcher label / iOS display name: **Bill Splitter**.

Dev/test: `flutter_test`, `mocktail` for repository/service mocking.

---

## 10. Testing Strategy

- **Unit tests:** split calculation service, settle-up algorithm, currency/rounding
  utils, view models — the highest-value, framework-independent logic.
- **Widget tests:** reusable widgets and each screen's core interactions.
- Target: full coverage of `core/services` and `shared/utils`.

---

## 11. Out of Scope (v1)

- Cloud sync / accounts / authentication (app is intentionally offline-only).
- Multi-currency conversion.
- Receipt scanning / OCR.
- Sharing/exporting bills (PDF, share sheet) — candidate for v2.
- Push notifications.

---

## 12. Open Items / Future Enhancements

- Additional languages (infrastructure ready).
- Export & share a bill summary.
- Bill categories, tags, or grouping.
- Per-person history/analytics view.
```
