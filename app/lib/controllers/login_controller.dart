import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

class LoginController with ChangeNotifier {
  final AuthenticationService authenticationService;
  final IdentityService identityService;

  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginController(this.authenticationService, this.identityService)
      : emailController = TextEditingController(),
        passwordController = TextEditingController();

  Future<bool> loginAsParent() async {
    AppResponse<String> response = await authenticationService.loginAsParent(
        emailController.text, passwordController.text);
    if (response.isSuccess()) {
      identityService.removeParentId();
      return true;
    } else
      UIHelper.showToast(msg: response.error);
    return false;
  }
}
