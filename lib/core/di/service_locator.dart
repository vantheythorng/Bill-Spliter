import 'package:get_it/get_it.dart';

import '../dao/bills/bill_dao.dart';
import '../repository/bills/bill_repository_impl.dart';
import '../repository/bills/bill_repository.dart';
import '../services/bills/settle_up_service.dart';
import '../services/bills/split_service.dart';
import '../dao/people/person_dao.dart';
import '../repository/people/person_repository_impl.dart';
import '../repository/people/person_repository.dart';
import '../database/app_database.dart';
import '../preferences/app_preferences.dart';

/// Global service locator. Repositories, services, the database and preferences
/// are registered here once at startup and injected into view models.
final GetIt getIt = GetIt.instance;

/// Registers all singletons. Must be awaited before `runApp`.
Future<void> setupServiceLocator() async {
  // Preferences (async initialization).
  final preferences = await AppPreferences.create();
  getIt.registerSingleton<AppPreferences>(preferences);

  // Database.
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // DAOs.
  getIt.registerLazySingleton<PersonDao>(() => PersonDao(getIt()));
  getIt.registerLazySingleton<BillDao>(() => BillDao(getIt()));

  // Repositories.
  getIt.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<BillRepository>(
    () => BillRepositoryImpl(getIt()),
  );

  // Pure calculation services.
  getIt.registerLazySingleton<SettleUpService>(() => const SettleUpService());
  getIt.registerLazySingleton<SplitService>(
    () => SplitService(settleUp: getIt<SettleUpService>()),
  );
}
