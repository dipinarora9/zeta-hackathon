import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zeta_hackathon/routes.dart';
import 'package:zeta_hackathon/services/cache_service.dart';

import 'dependency_injector.dart' as sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await sl.init();
  bool _ = await sl.sl<CacheService<String>>().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeta Hackathon',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initialScreen,
      onGenerateRoute: (s) => Routes.generateRoutes(s),
    );
  }
}
