import 'package:get_it/get_it.dart';
import 'package:zeta_hackathon/controllers/children_controller.dart';
import 'package:zeta_hackathon/controllers/homepage/parent_homepage_controller.dart';
import 'package:zeta_hackathon/controllers/login_controller.dart';
import 'package:zeta_hackathon/controllers/transaction_controller.dart';
import 'package:zeta_hackathon/services/analytics_service.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/database_service.dart';
import 'package:zeta_hackathon/services/notification_service.dart';
import 'package:zeta_hackathon/services/transaction_service.dart';

import 'controllers/homepage/child_homepage_controller.dart';
import 'controllers/pocket_money_plan_controller.dart';
import 'models/user/child.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Controllers
  ///
  sl.registerFactory<LoginController>(
      () => LoginController(sl<AuthenticationService>()));
  sl.registerFactory<ChildHomepageController>(() => ChildHomepageController());
  sl.registerFactory<ParentHomepageController>(
      () => ParentHomepageController());
  sl.registerFactoryParam<ChildrenController, Child, void>(
      (p1, _) => ChildrenController(p1, sl<DatabaseService>()));
  sl.registerFactory<PocketMoneyPlanController>(
      () => PocketMoneyPlanController(sl<DatabaseService>())..initialize());
  sl.registerFactory<TransactionController>(() => TransactionController());

  ///Services
  ///
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  sl.registerLazySingleton<AuthenticationService>(
      () => AuthenticationService());
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());
  sl.registerLazySingleton<NotificationService>(
      () => NotificationService()..initialize());
  sl.registerLazySingleton<TransactionService>(
    () => TransactionService(sl<DatabaseService>()),
  );
}
