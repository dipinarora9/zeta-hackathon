import 'package:flutter/material.dart';

import 'screens/authentication/child_login.dart';
import 'screens/authentication/parent_login.dart';
import 'screens/child_homepage.dart';
import 'screens/homepage.dart';
import 'screens/initial_screen.dart';
import 'screens/modify_child_screen.dart';
import 'screens/payment_confirmation_screen.dart';
import 'screens/transaction_screen.dart';

class Routes {
  static const String loginChild = '/loginChild';
  static const String loginParent = '/loginParent';
  static const String homepageChild = '/homepageChild';
  static const String homepage = '/homepage';
  static const String modifyChild = '/modifyChild';
  static const String paymentConfirmation = '/paymentConfirmation';
  static const String transactionScreen = '/transactionScreen';

  static final Map<String, WidgetBuilder> staticRoutes = {
    Routes.modifyChild: (context) => ModifyChildScreen(),
    Routes.loginChild: (context) => ChildLogin(),
    Routes.loginParent: (context) => ParentLogin(),
    Routes.homepageChild: (context) => ChildHomepageScreen(),
    Routes.homepage: (context) => HomepageScreen(),
    Routes.paymentConfirmation: (context) => PaymentConfirmationScreen(),
    Routes.transactionScreen: (context) => TransactionScreen(),
  };

  static Route<dynamic>? generateRoutes(RouteSettings routeSettings) {
    if (staticRoutes[routeSettings.name] != null) {
      return MaterialPageRoute(
          builder: staticRoutes[routeSettings.name]!, settings: routeSettings);
    }
    switch (routeSettings.name) {
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => InitialScreen(),
        );
    }
  }
}
