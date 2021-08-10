import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/pocket_money_plan_controller.dart';
import 'dependency_injector.dart' as sl;
import 'screens/allow_payment_screen.dart';
import 'screens/authentication/child_login.dart';
import 'screens/authentication/parent_login.dart';
import 'screens/authentication/signup.dart';
import 'screens/child_homepage.dart';
import 'screens/homepage.dart';
import 'screens/initial_screen.dart';
import 'screens/modify_child_screen.dart';
import 'screens/pocket_money_plans_screen.dart';
import 'screens/transaction_screen.dart';

class Routes {
  static final di = sl.sl;
  static const String initialScreen = '/';
  static const String signUp = '/signup';
  static const String loginChild = '/loginChild';
  static const String loginParent = '/loginParent';
  static const String homepageChild = '/homepageChild';
  static const String homepage = '/homepage';
  static const String modifyChild = '/modifyChild';
  static const String allowPaymentScreen = '/allowPaymentScreen';
  static const String transactionScreen = '/transactionScreen';
  static const String pocketMoneyPlans = '/pocketMoneyPlans';

  static final Map<String, WidgetBuilder> staticRoutes = {
    Routes.modifyChild: (context) => ModifyChildScreen(),
    Routes.signUp: (context) => SignUpScreen(),
    Routes.loginChild: (context) => ChildLogin(),
    Routes.loginParent: (context) => ParentLogin(),
    Routes.homepageChild: (context) => ChildHomepageScreen(),
    Routes.homepage: (context) => HomepageScreen(),
    Routes.allowPaymentScreen: (context) => AllowPaymentScreen(),
    Routes.transactionScreen: (context) => TransactionScreen(),
  };

  static Route<dynamic>? generateRoutes(RouteSettings routeSettings) {
    if (staticRoutes[routeSettings.name] != null) {
      return MaterialPageRoute(
          builder: staticRoutes[routeSettings.name]!, settings: routeSettings);
    }
    switch (routeSettings.name) {
      case Routes.pocketMoneyPlans:
        return MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            child: PocketMoneyPlanScreen(),
            create: (_) => di<PocketMoneyPlanController>(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => InitialScreen(),
        );
    }
  }
}
