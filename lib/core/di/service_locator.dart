import 'package:get_it/get_it.dart';

import '../../features/bills/data/bill_dao.dart';
import '../../features/bills/data/bill_repository_impl.dart';
import '../../features/bills/domain/bill_repository.dart';
import '../../features/bills/domain/services/settle_up_service.dart';
import '../../features/bills/domain/services/split_service.dart';
import '../../features/people/data/person_dao.dart';
import '../../features/people/data/person_repository_impl.dart';
import '../../features/people/domain/person_repository.dart';
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
