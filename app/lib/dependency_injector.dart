import 'package:get_it/get_it.dart';
import 'package:zeta_hackathon/controllers/children_controller.dart';
import 'package:zeta_hackathon/controllers/homepage/parent_homepage_controller.dart';
import 'package:zeta_hackathon/controllers/login_controller.dart';
import 'package:zeta_hackathon/controllers/transaction_controller.dart';
import 'package:zeta_hackathon/services/analytics_service.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/cache_service.dart';
import 'package:zeta_hackathon/services/database_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';
import 'package:zeta_hackathon/services/notification_service.dart';
import 'package:zeta_hackathon/services/scanner_service.dart';
import 'package:zeta_hackathon/services/transaction_service.dart';

import 'controllers/homepage/child_homepage_controller.dart';
import 'controllers/pocket_money_plan_controller.dart';
import 'controllers/signup_controller.dart';
import 'models/user/child.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Controllers
  ///
  sl.registerFactory<LoginController>(() => LoginController(
        sl<AuthenticationService>(),
        sl<IdentityService>(),
      ));
  sl.registerFactory<ChildHomepageController>(() => ChildHomepageController(
        sl<DatabaseService>(),
        sl<IdentityService>(),
        sl<AuthenticationService>(),
      ));
  sl.registerFactory<ParentHomepageController>(() => ParentHomepageController(
        sl<DatabaseService>(),
        sl<AnalyticsService>(),
        sl<IdentityService>(),
        sl<AuthenticationService>(),
      )..initialize());
  sl.registerFactoryParam<ChildrenController, Child, void>(
    (p1, _) => ChildrenController(
      p1,
      sl<AuthenticationService>(),
      sl<DatabaseService>(),
      sl<IdentityService>(),
    )..initialize(),
  );
  sl.registerFactory<PocketMoneyPlanController>(() => PocketMoneyPlanController(
        sl<DatabaseService>(),
        sl<IdentityService>(),
      )..initialize());
  sl.registerFactory<TransactionController>(() => TransactionController(
        sl<TransactionService>(),
        sl<IdentityService>(),
        sl<ScannerService>(),
      ));
  sl.registerFactory<SignUpController>(() => SignUpController(
        sl<AuthenticationService>(),
        sl<DatabaseService>(),
      ));

  ///Services
  ///
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  sl.registerLazySingleton<AuthenticationService>(
      () => AuthenticationService());
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());
  sl.registerLazySingleton<CacheService<String>>(() => CacheService<String>());
  sl.registerLazySingleton<ScannerService>(() => ScannerService());
  sl.registerLazySingleton<IdentityService>(
      () => IdentityService(sl<CacheService<String>>()));
  sl.registerLazySingleton<NotificationService>(
      () => NotificationService()..initialize());
  sl.registerLazySingleton<TransactionService>(
    () => TransactionService(sl<DatabaseService>(), sl<IdentityService>()),
  );
}
