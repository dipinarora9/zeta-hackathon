import 'package:flutter/foundation.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';

class LoginController with ChangeNotifier {
  final AuthenticationService authenticationService;

  LoginController(this.authenticationService);

  loginAsParent() {
    authenticationService.loginAsParent();
  }

  loginAsChild() {
    authenticationService.loginAsParent();
  }
}
