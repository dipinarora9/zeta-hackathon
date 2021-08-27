import 'package:get_it/get_it.dart';
import 'package:zeta_hackathon/controllers/children_controller.dart';
import 'package:zeta_hackathon/controllers/homepage/parent_homepage_controller.dart';
import 'package:zeta_hackathon/controllers/login_controller.dart';
import 'package:zeta_hackathon/controllers/transaction_controller.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/services/analytics_service.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/cache_service.dart';
import 'package:zeta_hackathon/services/cloud_functions_service.dart';
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
        sl<ScannerService>(),
      )..initialize());
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
      sl<CloudFunctionsService>(),
    )..initialize(),
  );
  sl.registerFactory<PocketMoneyPlanController>(() => PocketMoneyPlanController(
        sl<DatabaseService>(),
        sl<IdentityService>(),
      )..initialize());
  sl.registerFactoryParam<TransactionController, UserObject, void>(
      (p1, _) => TransactionController(
            p1,
            sl<TransactionService>(),
            sl<IdentityService>(),
            sl<CloudFunctionsService>(),
          ));
  sl.registerFactory<SignUpController>(() => SignUpController(
        sl<AuthenticationService>(),
        sl<DatabaseService>(),
        sl<CloudFunctionsService>(),
      ));

  ///Services
  ///
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  sl.registerLazySingleton<AuthenticationService>(
      () => AuthenticationService());
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());
  sl.registerSingleton<NotificationService>(
      NotificationService()..initialize());
  sl.registerSingleton<CacheService<String>>(CacheService<String>());
  sl.registerLazySingleton<ScannerService>(() => ScannerService());
  sl.registerLazySingleton<CloudFunctionsService>(
      () => CloudFunctionsService());
  sl.registerLazySingleton<IdentityService>(
      () => IdentityService(sl<CacheService<String>>()));
  sl.registerLazySingleton<TransactionService>(
    () => TransactionService(sl<DatabaseService>(), sl<IdentityService>()),
  );
}
