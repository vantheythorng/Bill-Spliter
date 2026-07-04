import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// Dev entry point. Run with `--flavor dev -t lib/main_dev.dart`.
Future<void> main() => bootstrap(Flavor.dev);
