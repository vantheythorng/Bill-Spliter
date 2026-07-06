// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bill Splitter';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingEqualTitle => 'Split equally';

  @override
  String get onboardingEqualBody =>
      'Divide any bill fairly among everyone in a single tap.';

  @override
  String get onboardingItemizedTitle => 'Split by item';

  @override
  String get onboardingItemizedBody =>
      'Assign each item to who consumed it and split only what they shared.';

  @override
  String get onboardingSettleTitle => 'Settle up';

  @override
  String get onboardingSettleBody =>
      'See exactly who pays whom with the fewest transfers.';

  @override
  String get onboardingHistoryTitle => 'Keep your history';

  @override
  String get onboardingHistoryBody =>
      'Every bill is saved on your device — no account, no internet needed.';

  @override
  String get billsTitle => 'Bills';

  @override
  String get billsEmptyTitle => 'No bills yet';

  @override
  String get billsEmptyBody => 'Tap the + button to create your first bill.';

  @override
  String get billsNewBill => 'New bill';

  @override
  String get billTypeEqual => 'Equal';

  @override
  String get billTypeItemized => 'Itemized';

  @override
  String get billTypeParty => 'Party';

  @override
  String get billTypeEqualDescription =>
      'Split a total equally among everyone.';

  @override
  String get billTypeItemizedDescription =>
      'Assign items to people and settle up.';

  @override
  String get billTypePartyDescription =>
      'Everyone shares one pot; reimburse whoever overspent.';

  @override
  String get createBillTitle => 'Create bill';

  @override
  String get editBillTitle => 'Edit bill';

  @override
  String get billTitleLabel => 'Title';

  @override
  String get billTitleHint => 'e.g. Dinner at Luigi\'s';

  @override
  String get billTypeLabel => 'Split type';

  @override
  String get participantsLabel => 'Participants';

  @override
  String get addParticipantHint => 'Add a person';

  @override
  String quickAddPerson(Object name) {
    return 'Add \"$name\"';
  }

  @override
  String get next => 'Next';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get equalEditorTitle => 'Equal split';

  @override
  String get totalAmountLabel => 'Total amount';

  @override
  String get perPersonShare => 'Each person pays';

  @override
  String get itemizedEditorTitle => 'Items';

  @override
  String get addItem => 'Add item';

  @override
  String get itemNameLabel => 'Item name';

  @override
  String get itemPriceLabel => 'Price';

  @override
  String get itemQuantityLabel => 'Qty';

  @override
  String get assignedToLabel => 'Shared by';

  @override
  String get assignEveryone => 'Everyone';

  @override
  String get noItemsYet => 'No items yet. Add the first one.';

  @override
  String get sharedCharges => 'Shared charges';

  @override
  String get paymentsLabel => 'Who paid';

  @override
  String get paidAmountLabel => 'Paid';

  @override
  String get partyEditorTitle => 'Contributions';

  @override
  String get addContribution => 'Add contribution';

  @override
  String get contributionLabelHint => 'What for? (optional)';

  @override
  String get contributionPayerLabel => 'Paid by';

  @override
  String get contributionAmountLabel => 'Amount';

  @override
  String get grandTotal => 'Grand total';

  @override
  String get equalShare => 'Equal share';

  @override
  String get noContributionsYet => 'No contributions yet. Add the first one.';

  @override
  String get billDetailTitle => 'Summary';

  @override
  String get breakdownLabel => 'Per-person breakdown';

  @override
  String get settleUpLabel => 'Settle up';

  @override
  String get owesLabel => 'owes';

  @override
  String get getsBackLabel => 'gets back';

  @override
  String getsBack(Object amount) {
    return 'gets back $amount';
  }

  @override
  String owesAmount(Object amount) {
    return 'owes $amount';
  }

  @override
  String get roundingExtraLabel => 'Extra collected';

  @override
  String get roundingShortLabel => 'Short of total';

  @override
  String get roundingExactLabel => 'Adds up exactly';

  @override
  String get allSettled => 'All settled — nobody owes anything.';

  @override
  String paysTo(Object from, Object to) {
    return '$from pays $to';
  }

  @override
  String get peopleTitle => 'People';

  @override
  String get peopleEmptyTitle => 'No people yet';

  @override
  String get peopleEmptyBody => 'Add people to reuse them across bills.';

  @override
  String get addPerson => 'Add person';

  @override
  String get editPerson => 'Edit person';

  @override
  String get personNameLabel => 'Name';

  @override
  String deletePersonTitle(Object name) {
    return 'Delete $name?';
  }

  @override
  String get deletePersonBody =>
      'This person isn\'t used in any bill and will be permanently removed.';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get reactivate => 'Reactivate';

  @override
  String get inactive => 'Inactive';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get chooseCurrency => 'Choose currency';

  @override
  String get settingsRounding => 'Rounding';

  @override
  String get settingsRoundingHint =>
      'How to round each person\'s share when a bill doesn\'t divide evenly.';

  @override
  String get roundingUpTitle => 'Everyone pays the same (rounded up)';

  @override
  String get roundingUpDetail => '100 split 3 ways → 33.34 each';

  @override
  String get roundingDownTitle => 'Everyone pays the same (rounded down)';

  @override
  String get roundingDownDetail => '100 split 3 ways → 33.33 each';

  @override
  String get roundingExactTitle => 'Exact total, cents may differ';

  @override
  String get roundingExactDetail => '100 split 3 ways → 33.34, 33.33, 33.33';

  @override
  String get settingsPeople => 'Manage people';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get languageEnglish => 'English';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationInvalidNumber => 'Enter a valid number';

  @override
  String get validationPositive => 'Must be greater than zero';

  @override
  String get validationSelectParticipants => 'Select at least one participant';

  @override
  String get deleteBillTitle => 'Delete this bill?';

  @override
  String get deleteBillBody => 'This cannot be undone.';
}
