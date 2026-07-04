// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Khmer Central Khmer (`km`).
class AppLocalizationsKm extends AppLocalizations {
  AppLocalizationsKm([String locale = 'km']) : super(locale);

  @override
  String get appTitle => 'កម្មវិធីចែកវិក្កយបត្រ';

  @override
  String get onboardingSkip => 'រំលង';

  @override
  String get onboardingNext => 'បន្ទាប់';

  @override
  String get onboardingGetStarted => 'ចាប់ផ្តើម';

  @override
  String get onboardingEqualTitle => 'ចែកស្មើៗគ្នា';

  @override
  String get onboardingEqualBody =>
      'ចែកវិក្កយបត្រណាមួយឱ្យស្មើគ្នាដល់អ្នករាល់គ្នាតែម្តង។';

  @override
  String get onboardingItemizedTitle => 'ចែកតាមមុខទំនិញ';

  @override
  String get onboardingItemizedBody =>
      'កំណត់មុខទំនិញនីមួយៗទៅអ្នកដែលបានប្រើ ហើយចែកតែអ្វីដែលពួកគេចែករំលែក។';

  @override
  String get onboardingSettleTitle => 'សងគ្នា';

  @override
  String get onboardingSettleBody =>
      'មើលឱ្យច្បាស់ថានរណាសងឱ្យនរណា ដោយប្រតិបត្តិការតិចបំផុត។';

  @override
  String get onboardingHistoryTitle => 'រក្សាទុកប្រវត្តិ';

  @override
  String get onboardingHistoryBody =>
      'វិក្កយបត្រទាំងអស់ត្រូវបានរក្សាទុកនៅលើឧបករណ៍របស់អ្នក — មិនត្រូវការគណនី ឬអ៊ីនធឺណិតទេ។';

  @override
  String get billsTitle => 'វិក្កយបត្រ';

  @override
  String get billsEmptyTitle => 'មិនទាន់មានវិក្កយបត្រ';

  @override
  String get billsEmptyBody =>
      'ចុចប៊ូតុង + ដើម្បីបង្កើតវិក្កយបត្រដំបូងរបស់អ្នក។';

  @override
  String get billsNewBill => 'វិក្កយបត្រថ្មី';

  @override
  String get billTypeEqual => 'ស្មើគ្នា';

  @override
  String get billTypeItemized => 'តាមមុខទំនិញ';

  @override
  String get billTypeParty => 'ពិធីជប់លៀង';

  @override
  String get billTypeEqualDescription =>
      'ចែកចំនួនសរុបស្មើៗគ្នាដល់អ្នករាល់គ្នា។';

  @override
  String get billTypeItemizedDescription => 'កំណត់មុខទំនិញទៅមនុស្ស ហើយសងគ្នា។';

  @override
  String get billTypePartyDescription =>
      'អ្នករាល់គ្នាចែករំលែកមូលនិធិរួម; សងវិញដល់អ្នកដែលចំណាយលើស។';

  @override
  String get createBillTitle => 'បង្កើតវិក្កយបត្រ';

  @override
  String get editBillTitle => 'កែវិក្កយបត្រ';

  @override
  String get billTitleLabel => 'ចំណងជើង';

  @override
  String get billTitleHint => 'ឧ. អាហារពេលល្ងាចនៅ Luigi\'s';

  @override
  String get billTypeLabel => 'ប្រភេទការចែក';

  @override
  String get participantsLabel => 'អ្នកចូលរួម';

  @override
  String get addParticipantHint => 'បន្ថែមមនុស្ស';

  @override
  String quickAddPerson(Object name) {
    return 'បន្ថែម \"$name\"';
  }

  @override
  String get next => 'បន្ទាប់';

  @override
  String get save => 'រក្សាទុក';

  @override
  String get cancel => 'បោះបង់';

  @override
  String get delete => 'លុប';

  @override
  String get edit => 'កែ';

  @override
  String get done => 'រួចរាល់';

  @override
  String get equalEditorTitle => 'ការចែកស្មើគ្នា';

  @override
  String get totalAmountLabel => 'ចំនួនសរុប';

  @override
  String get perPersonShare => 'ម្នាក់ៗត្រូវបង់';

  @override
  String get itemizedEditorTitle => 'មុខទំនិញ';

  @override
  String get addItem => 'បន្ថែមមុខទំនិញ';

  @override
  String get itemNameLabel => 'ឈ្មោះមុខទំនិញ';

  @override
  String get itemPriceLabel => 'តម្លៃ';

  @override
  String get itemQuantityLabel => 'បរិមាណ';

  @override
  String get assignedToLabel => 'ចែករំលែកដោយ';

  @override
  String get assignEveryone => 'អ្នករាល់គ្នា';

  @override
  String get noItemsYet => 'មិនទាន់មានមុខទំនិញ។ បន្ថែមមុខទំនិញដំបូង។';

  @override
  String get sharedCharges => 'ការចំណាយរួម';

  @override
  String get paymentsLabel => 'នរណាបានបង់';

  @override
  String get paidAmountLabel => 'បានបង់';

  @override
  String get partyEditorTitle => 'ការចូលរួមចំណាយ';

  @override
  String get addContribution => 'បន្ថែមការចូលរួមចំណាយ';

  @override
  String get contributionLabelHint => 'សម្រាប់អ្វី? (ស្រេចចិត្ត)';

  @override
  String get contributionPayerLabel => 'បង់ដោយ';

  @override
  String get contributionAmountLabel => 'ចំនួន';

  @override
  String get grandTotal => 'សរុបទាំងអស់';

  @override
  String get equalShare => 'ចំណែកស្មើគ្នា';

  @override
  String get noContributionsYet => 'មិនទាន់មានការចូលរួមចំណាយ។ បន្ថែមមុនដំបូង។';

  @override
  String get billDetailTitle => 'សេចក្តីសង្ខេប';

  @override
  String get breakdownLabel => 'ការបែងចែកតាមមនុស្សម្នាក់ៗ';

  @override
  String get settleUpLabel => 'សងគ្នា';

  @override
  String get owesLabel => 'ជំពាក់';

  @override
  String get getsBackLabel => 'ទទួលបានវិញ';

  @override
  String getsBack(Object amount) {
    return 'ទទួលបានវិញ $amount';
  }

  @override
  String owesAmount(Object amount) {
    return 'ជំពាក់ $amount';
  }

  @override
  String get roundingExtraLabel => 'ប្រមូលបានលើស';

  @override
  String get roundingShortLabel => 'ខ្វះពីចំនួនសរុប';

  @override
  String get roundingExactLabel => 'បូកបានត្រឹមត្រូវ';

  @override
  String get allSettled => 'សងគ្នារួចរាល់ — គ្មាននរណាជំពាក់អ្វីទេ។';

  @override
  String paysTo(Object from, Object to) {
    return '$from សងឱ្យ $to';
  }

  @override
  String get peopleTitle => 'មនុស្ស';

  @override
  String get peopleEmptyTitle => 'មិនទាន់មានមនុស្ស';

  @override
  String get peopleEmptyBody =>
      'បន្ថែមមនុស្សដើម្បីប្រើឡើងវិញនៅទូទាំងវិក្កយបត្រ។';

  @override
  String get addPerson => 'បន្ថែមមនុស្ស';

  @override
  String get editPerson => 'កែមនុស្ស';

  @override
  String get personNameLabel => 'ឈ្មោះ';

  @override
  String deletePersonTitle(Object name) {
    return 'លុប $name?';
  }

  @override
  String get deletePersonBody =>
      'មនុស្សនេះត្រូវបានប្រើក្នុងវិក្កយបត្រដែលមានស្រាប់ ដែលនឹងរក្សាប្រវត្តិរបស់ពួកគេ។';

  @override
  String get settingsTitle => 'ការកំណត់';

  @override
  String get settingsAppearance => 'រូបរាង';

  @override
  String get settingsTheme => 'ស្បែក';

  @override
  String get themeSystem => 'តាមប្រព័ន្ធ';

  @override
  String get themeLight => 'ភ្លឺ';

  @override
  String get themeDark => 'ងងឹត';

  @override
  String get settingsLanguage => 'ភាសា';

  @override
  String get settingsCurrency => 'រូបិយប័ណ្ណ';

  @override
  String get chooseCurrency => 'ជ្រើសរើសរូបិយប័ណ្ណ';

  @override
  String get settingsRounding => 'ការបង្គត់';

  @override
  String get settingsRoundingHint =>
      'របៀបបង្គត់ចំណែករបស់មនុស្សម្នាក់ៗ នៅពេលវិក្កយបត្រចែកមិនស្មើគ្នា។';

  @override
  String get roundingUpTitle => 'ម្នាក់ៗបង់ស្មើគ្នា (បង្គត់ឡើង)';

  @override
  String get roundingUpDetail => '១០០ ចែក ៣ → ៣៣.៣៤ ម្នាក់';

  @override
  String get roundingDownTitle => 'ម្នាក់ៗបង់ស្មើគ្នា (បង្គត់ចុះ)';

  @override
  String get roundingDownDetail => '១០០ ចែក ៣ → ៣៣.៣៣ ម្នាក់';

  @override
  String get roundingExactTitle => 'សរុបត្រឹមត្រូវ សេនអាចខុសគ្នា';

  @override
  String get roundingExactDetail => '១០០ ចែក ៣ → ៣៣.៣៤, ៣៣.៣៣, ៣៣.៣៣';

  @override
  String get settingsPeople => 'គ្រប់គ្រងមនុស្ស';

  @override
  String get settingsAbout => 'អំពី';

  @override
  String get settingsVersion => 'កំណែ';

  @override
  String get languageEnglish => 'អង់គ្លេស';

  @override
  String get validationRequired => 'ត្រូវការ';

  @override
  String get validationInvalidNumber => 'បញ្ចូលលេខត្រឹមត្រូវ';

  @override
  String get validationPositive => 'ត្រូវតែធំជាងសូន្យ';

  @override
  String get validationSelectParticipants => 'ជ្រើសរើសអ្នកចូលរួមយ៉ាងតិចម្នាក់';

  @override
  String get deleteBillTitle => 'លុបវិក្កយបត្រនេះ?';

  @override
  String get deleteBillBody => 'សកម្មភាពនេះមិនអាចត្រឡប់វិញបានទេ។';
}
