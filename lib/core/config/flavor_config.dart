/// Build flavors that mirror the Android product flavors declared in
/// `android/app/build.gradle.kts`. The active flavor is selected by the entry
/// point (`main_dev.dart`, `main_staging.dart`, `main.dart`) via
/// [FlavorConfig.initialize].
enum Flavor { dev, staging, prod }

/// Holds the flavor the app was launched with. Initialize it once from the
/// entry point before `runApp`, then read [FlavorConfig.instance] anywhere.
class FlavorConfig {
  FlavorConfig._(this.flavor, this.name);

  final Flavor flavor;

  /// Human-readable name, e.g. shown in debug banners or diagnostics.
  final String name;

  static FlavorConfig? _instance;

  /// Sets the active flavor. Safe to call multiple times with the same flavor
  /// (useful in tests); the first call wins.
  static FlavorConfig initialize(Flavor flavor) {
    return _instance ??= FlavorConfig._(flavor, _nameFor(flavor));
  }

  /// The active flavor config. Falls back to [Flavor.prod] if an entry point
  /// forgot to initialize it.
  static FlavorConfig get instance => _instance ??= initialize(Flavor.prod);

  static bool get isDev => instance.flavor == Flavor.dev;
  static bool get isStaging => instance.flavor == Flavor.staging;
  static bool get isProd => instance.flavor == Flavor.prod;

  static String _nameFor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return 'Bill Splitter Dev';
      case Flavor.staging:
        return 'Bill Splitter Staging';
      case Flavor.prod:
        return 'Bill Splitter';
    }
  }
}
