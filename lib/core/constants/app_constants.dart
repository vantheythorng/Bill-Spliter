/// App-wide constants that are not user-configurable.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Bill Splitter';
  static const String appVersion = '1.0.0';

  static const String databaseName = 'bill_splitter.db';
  static const int databaseVersion = 1;

  /// Number of distinct avatar colors derived from a person's [colorSeed].
  static const int avatarColorCount = 12;
}
