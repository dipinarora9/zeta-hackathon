import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';
import 'package:zeta_hackathon/widgets/debug_popup.dart';
import 'package:zeta_hackathon/widgets/qr_widget.dart';

import 'controllers/children_controller.dart';
import 'controllers/homepage/child_homepage_controller.dart';
import 'controllers/homepage/parent_homepage_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/pocket_money_plan_controller.dart';
import 'controllers/signup_controller.dart';
import 'controllers/transaction_controller.dart';
import 'dependency_injector.dart' as sl;
import 'screens/allow_payment_screen.dart';
import 'screens/authentication/parent_login.dart';
import 'screens/authentication/signup.dart';
import 'screens/child_homepage.dart';
import 'screens/homepage.dart';
import 'screens/initial_screen.dart';
import 'screens/modify_child_screen.dart';
import 'screens/pocket_money_plans_screen.dart';
import 'screens/transaction_screen.dart';
import 'services/dynamic_links_service.dart';

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
  static const String qrScreen = '/qrCode';
  static const String debugScreen = '/debugScreen';

  static final Map<String, WidgetBuilder> staticRoutes = {
    Routes.initialScreen: (context) {
      DynamicLinks.handleDynamicLink(context);
      return InitialScreen();
    },
    Routes.allowPaymentScreen: (context) => AllowPaymentScreen(),
  };

  static Route<dynamic>? generateRoutes(RouteSettings routeSettings) {
    // if (!di<IdentityService>().isServiceReady())
    //   return MaterialPageRoute(
    //     builder: (_) => Scaffold(
    //       body: Center(child: CircularProgressIndicator()),
    //     ),
    //   );

    String uid = di<IdentityService>().getUID();
    print('HERE IS IT called from here');
    String? parentId = di<IdentityService>().getParentId();
    if (routeSettings.name == Routes.initialScreen &&
        uid != '' &&
        (parentId == null || parentId == ''))
      return MaterialPageRoute(
        builder: (BuildContext context) => ChangeNotifierProvider(
          child: HomepageScreen(),
          create: (_) => di<ParentHomepageController>(),
        ),
      );
    else if (routeSettings.name == Routes.initialScreen &&
        uid != '' &&
        parentId != null &&
        parentId != '')
      return MaterialPageRoute(
        builder: (BuildContext context) => ChangeNotifierProvider(
          child: ChildHomepageScreen(),
          create: (_) => di<ChildHomepageController>(),
        ),
      );
    else if (staticRoutes[routeSettings.name] != null) {
      return MaterialPageRoute(
          builder: staticRoutes[routeSettings.name]!, settings: routeSettings);
    } else
      switch (routeSettings.name) {
        case Routes.homepage:
          return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
              child: HomepageScreen(),
              create: (_) => di<ParentHomepageController>(),
            ),
          );
        case Routes.homepageChild:
          return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
              child: ChildHomepageScreen(),
              create: (_) => di<ChildHomepageController>(),
            ),
          );
        case Routes.qrScreen:
          return MaterialPageRoute(
            builder: (BuildContext context) => QRScreen(
              data: routeSettings.arguments as String,
            ),
          );
        case Routes.debugScreen:
          return MaterialPageRoute(
            builder: (BuildContext context) => DebugPopUp(),
          );
        case Routes.modifyChild:
          return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
              child: ModifyChildScreen(),
              create: (_) => di<ChildrenController>(
                  param1: routeSettings.arguments as Child),
            ),
          );
        case Routes.signUp:
          return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
              child: SignUpScreen(),
              create: (_) => di<SignUpController>(),
            ),
          );
        case Routes.loginParent:
          return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
              child: ParentLogin(),
              create: (_) => di<LoginController>(),
            ),
          );

        case Routes.pocketMoneyPlans:
          return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
              child: PocketMoneyPlanScreen(),
              create: (_) => di<PocketMoneyPlanController>(),
            ),
          );
        case Routes.transactionScreen:
          return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
              child: TransactionScreen(),
              create: (_) => di<TransactionController>(
                param1: routeSettings.arguments as UserObject,
              ),
            ),
          );
        default:
          return MaterialPageRoute(builder: (_) => InitialScreen());
      }
  }
}
