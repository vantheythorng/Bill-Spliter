import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// Default (prod) entry point. Run with `--flavor prod`.
Future<void> main() => bootstrap(Flavor.prod);
