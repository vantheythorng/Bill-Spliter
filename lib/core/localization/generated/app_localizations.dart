import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Bill Splitter'**
  String get appTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingEqualTitle.
  ///
  /// In en, this message translates to:
  /// **'Split equally'**
  String get onboardingEqualTitle;

  /// No description provided for @onboardingEqualBody.
  ///
  /// In en, this message translates to:
  /// **'Divide any bill fairly among everyone in a single tap.'**
  String get onboardingEqualBody;

  /// No description provided for @onboardingItemizedTitle.
  ///
  /// In en, this message translates to:
  /// **'Split by item'**
  String get onboardingItemizedTitle;

  /// No description provided for @onboardingItemizedBody.
  ///
  /// In en, this message translates to:
  /// **'Assign each item to who consumed it and split only what they shared.'**
  String get onboardingItemizedBody;

  /// No description provided for @onboardingSettleTitle.
  ///
  /// In en, this message translates to:
  /// **'Settle up'**
  String get onboardingSettleTitle;

  /// No description provided for @onboardingSettleBody.
  ///
  /// In en, this message translates to:
  /// **'See exactly who pays whom with the fewest transfers.'**
  String get onboardingSettleBody;

  /// No description provided for @onboardingHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your history'**
  String get onboardingHistoryTitle;

  /// No description provided for @onboardingHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'Every bill is saved on your device — no account, no internet needed.'**
  String get onboardingHistoryBody;

  /// No description provided for @billsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get billsTitle;

  /// No description provided for @billsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No bills yet'**
  String get billsEmptyTitle;

  /// No description provided for @billsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first bill.'**
  String get billsEmptyBody;

  /// No description provided for @billsNewBill.
  ///
  /// In en, this message translates to:
  /// **'New bill'**
  String get billsNewBill;

  /// No description provided for @billTypeEqual.
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get billTypeEqual;

  /// No description provided for @billTypeItemized.
  ///
  /// In en, this message translates to:
  /// **'Itemized'**
  String get billTypeItemized;

  /// No description provided for @billTypeParty.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get billTypeParty;

  /// No description provided for @billTypeEqualDescription.
  ///
  /// In en, this message translates to:
  /// **'Split a total equally among everyone.'**
  String get billTypeEqualDescription;

  /// No description provided for @billTypeItemizedDescription.
  ///
  /// In en, this message translates to:
  /// **'Assign items to people and settle up.'**
  String get billTypeItemizedDescription;

  /// No description provided for @billTypePartyDescription.
  ///
  /// In en, this message translates to:
  /// **'Everyone shares one pot; reimburse whoever overspent.'**
  String get billTypePartyDescription;

  /// No description provided for @createBillTitle.
  ///
  /// In en, this message translates to:
  /// **'Create bill'**
  String get createBillTitle;

  /// No description provided for @editBillTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit bill'**
  String get editBillTitle;

  /// No description provided for @billTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get billTitleLabel;

  /// No description provided for @billTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dinner at Luigi\'s'**
  String get billTitleHint;

  /// No description provided for @billTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Split type'**
  String get billTypeLabel;

  /// No description provided for @participantsLabel.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participantsLabel;

  /// No description provided for @addParticipantHint.
  ///
  /// In en, this message translates to:
  /// **'Add a person'**
  String get addParticipantHint;

  /// No description provided for @quickAddPerson.
  ///
  /// In en, this message translates to:
  /// **'Add \"{name}\"'**
  String quickAddPerson(Object name);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @equalEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Equal split'**
  String get equalEditorTitle;

  /// No description provided for @totalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmountLabel;

  /// No description provided for @perPersonShare.
  ///
  /// In en, this message translates to:
  /// **'Each person pays'**
  String get perPersonShare;

  /// No description provided for @itemizedEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemizedEditorTitle;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @itemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemNameLabel;

  /// No description provided for @itemPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get itemPriceLabel;

  /// No description provided for @itemQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get itemQuantityLabel;

  /// No description provided for @assignedToLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared by'**
  String get assignedToLabel;

  /// No description provided for @assignEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get assignEveryone;

  /// No description provided for @noItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No items yet. Add the first one.'**
  String get noItemsYet;

  /// No description provided for @sharedCharges.
  ///
  /// In en, this message translates to:
  /// **'Shared charges'**
  String get sharedCharges;

  /// No description provided for @paymentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Who paid'**
  String get paymentsLabel;

  /// No description provided for @paidAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidAmountLabel;

  /// No description provided for @partyEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get partyEditorTitle;

  /// No description provided for @addContribution.
  ///
  /// In en, this message translates to:
  /// **'Add contribution'**
  String get addContribution;

  /// No description provided for @contributionLabelHint.
  ///
  /// In en, this message translates to:
  /// **'What for? (optional)'**
  String get contributionLabelHint;

  /// No description provided for @contributionPayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get contributionPayerLabel;

  /// No description provided for @contributionAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get contributionAmountLabel;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get grandTotal;

  /// No description provided for @equalShare.
  ///
  /// In en, this message translates to:
  /// **'Equal share'**
  String get equalShare;

  /// No description provided for @noContributionsYet.
  ///
  /// In en, this message translates to:
  /// **'No contributions yet. Add the first one.'**
  String get noContributionsYet;

  /// No description provided for @billDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get billDetailTitle;

  /// No description provided for @breakdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Per-person breakdown'**
  String get breakdownLabel;

  /// No description provided for @settleUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Settle up'**
  String get settleUpLabel;

  /// No description provided for @owesLabel.
  ///
  /// In en, this message translates to:
  /// **'owes'**
  String get owesLabel;

  /// No description provided for @getsBackLabel.
  ///
  /// In en, this message translates to:
  /// **'gets back'**
  String get getsBackLabel;

  /// No description provided for @getsBack.
  ///
  /// In en, this message translates to:
  /// **'gets back {amount}'**
  String getsBack(Object amount);

  /// No description provided for @owesAmount.
  ///
  /// In en, this message translates to:
  /// **'owes {amount}'**
  String owesAmount(Object amount);

  /// No description provided for @roundingExtraLabel.
  ///
  /// In en, this message translates to:
  /// **'Extra collected'**
  String get roundingExtraLabel;

  /// No description provided for @roundingShortLabel.
  ///
  /// In en, this message translates to:
  /// **'Short of total'**
  String get roundingShortLabel;

  /// No description provided for @roundingExactLabel.
  ///
  /// In en, this message translates to:
  /// **'Adds up exactly'**
  String get roundingExactLabel;

  /// No description provided for @allSettled.
  ///
  /// In en, this message translates to:
  /// **'All settled — nobody owes anything.'**
  String get allSettled;

  /// No description provided for @paysTo.
  ///
  /// In en, this message translates to:
  /// **'{from} pays {to}'**
  String paysTo(Object from, Object to);

  /// No description provided for @peopleTitle.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleTitle;

  /// No description provided for @peopleEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No people yet'**
  String get peopleEmptyTitle;

  /// No description provided for @peopleEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add people to reuse them across bills.'**
  String get peopleEmptyBody;

  /// No description provided for @addPerson.
  ///
  /// In en, this message translates to:
  /// **'Add person'**
  String get addPerson;

  /// No description provided for @editPerson.
  ///
  /// In en, this message translates to:
  /// **'Edit person'**
  String get editPerson;

  /// No description provided for @personNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get personNameLabel;

  /// No description provided for @deletePersonTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deletePersonTitle(Object name);

  /// No description provided for @deletePersonBody.
  ///
  /// In en, this message translates to:
  /// **'This person isn\'t used in any bill and will be permanently removed.'**
  String get deletePersonBody;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @reactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivate;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @chooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose currency'**
  String get chooseCurrency;

  /// No description provided for @settingsRounding.
  ///
  /// In en, this message translates to:
  /// **'Rounding'**
  String get settingsRounding;

  /// No description provided for @settingsRoundingHint.
  ///
  /// In en, this message translates to:
  /// **'How to round each person\'s share when a bill doesn\'t divide evenly.'**
  String get settingsRoundingHint;

  /// No description provided for @roundingUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Everyone pays the same (rounded up)'**
  String get roundingUpTitle;

  /// No description provided for @roundingUpDetail.
  ///
  /// In en, this message translates to:
  /// **'100 split 3 ways → 33.34 each'**
  String get roundingUpDetail;

  /// No description provided for @roundingDownTitle.
  ///
  /// In en, this message translates to:
  /// **'Everyone pays the same (rounded down)'**
  String get roundingDownTitle;

  /// No description provided for @roundingDownDetail.
  ///
  /// In en, this message translates to:
  /// **'100 split 3 ways → 33.33 each'**
  String get roundingDownDetail;

  /// No description provided for @roundingExactTitle.
  ///
  /// In en, this message translates to:
  /// **'Exact total, cents may differ'**
  String get roundingExactTitle;

  /// No description provided for @roundingExactDetail.
  ///
  /// In en, this message translates to:
  /// **'100 split 3 ways → 33.34, 33.33, 33.33'**
  String get roundingExactDetail;

  /// No description provided for @settingsPeople.
  ///
  /// In en, this message translates to:
  /// **'Manage people'**
  String get settingsPeople;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get validationRequired;

  /// No description provided for @validationInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get validationInvalidNumber;

  /// No description provided for @validationPositive.
  ///
  /// In en, this message translates to:
  /// **'Must be greater than zero'**
  String get validationPositive;

  /// No description provided for @validationSelectParticipants.
  ///
  /// In en, this message translates to:
  /// **'Select at least one participant'**
  String get validationSelectParticipants;

  /// No description provided for @deleteBillTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this bill?'**
  String get deleteBillTitle;

  /// No description provided for @deleteBillBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get deleteBillBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
