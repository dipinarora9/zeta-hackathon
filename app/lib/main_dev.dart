import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dependency_injector.dart' as sl;
import 'routes.dart';
import 'services/cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sl.init();
  bool _ = await sl.sl<CacheService<String>>().initialize();
  await Firebase.initializeApp();
  try {
    FirebaseFirestore.instance.settings =
        Settings(host: '192.168.1.5:3000', sslEnabled: false);
    FirebaseAuth.instance.useAuthEmulator('192.168.1.5', 9099);
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  } catch (e) {}
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
