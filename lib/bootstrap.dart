import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/config/flavor_config.dart';
import 'core/di/service_locator.dart';

/// Shared startup path for every flavor entry point. Sets the active [flavor],
/// wires up dependencies, and runs the app.
Future<void> bootstrap(Flavor flavor) async {
  FlavorConfig.initialize(flavor);
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await setupServiceLocator();
  runApp(const BillSplitterApp());
}
