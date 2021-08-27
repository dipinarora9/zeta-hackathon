import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/user/parent.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/database_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

class LoginController with ChangeNotifier {
  final AuthenticationService authenticationService;
  final IdentityService identityService;
  final DatabaseService databaseService;

  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginController(
      this.authenticationService, this.identityService, this.databaseService)
      : emailController = TextEditingController(),
        passwordController = TextEditingController();

  Future<bool> loginAsParent() async {
    AppResponse<String> response = await authenticationService.loginAsParent(
        emailController.text, passwordController.text);

    if (response.isSuccess()) {
      AppResponse<Parent> parentResponse =
          await databaseService.fetchParentDetails(uid: response.data!);
      if (!parentResponse.isSuccess()) {
        UIHelper.showToast(msg: parentResponse.error);
        return false;
      }
      identityService.removeParentId();
      Parent p = parentResponse.data!;
      identityService.setAccountHolderId(p.individualId);
      identityService.setAccountId(p.accountNumber);
      identityService.setPoolAccountId(p.poolAccountId);
      return true;
    } else
      UIHelper.showToast(msg: response.error);
    return false;
  }
}
