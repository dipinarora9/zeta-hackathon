import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';

class LoginController with ChangeNotifier {
  final AuthenticationService authenticationService;

  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginController(this.authenticationService)
      : emailController = TextEditingController(),
        passwordController = TextEditingController();

  loginAsParent() {
    authenticationService.loginAsParent();
  }

  loginAsChild() {
    authenticationService.loginAsParent();
  }
}
