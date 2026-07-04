import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// Staging entry point. Run with `--flavor staging -t lib/main_staging.dart`.
Future<void> main() => bootstrap(Flavor.staging);
