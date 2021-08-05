import 'package:flutter/material.dart';
import 'package:zeta_hackathon/screens/initial_screen.dart';
import 'package:zeta_hackathon/screens/modify_child_screen.dart';

class Routes {
  static const String modifyChild = '/modifyChild';

  static final Map<String, WidgetBuilder> staticRoutes = {
    Routes.modifyChild: (context) => ModifyChildScreen(),
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
