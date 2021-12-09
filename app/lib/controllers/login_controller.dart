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
  final Map<String, String> parentIds;
  String parentId;

  LoginController(
      this.authenticationService, this.identityService, this.databaseService)
      : parentIds = {
          'hjrmGuvkP7NVPaRcssiAqx1JUKk2': 'temptest',
          'eZgIQWaeXHhxLztcsGcgIROxXr53': 'prashant'
        },
        parentId = 'hjrmGuvkP7NVPaRcssiAqx1JUKk2',
        emailController = TextEditingController(),
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

  Future<bool> loginAsChild() async {
    AppResponse<String> response = await authenticationService.loginAsParent(
        emailController.text, passwordController.text);

    if (response.isSuccess()) {
      AppResponse<String> childUserId = await databaseService
          .fetchChildDetailsUsingEmail(parentId, emailController.text);
      if (!childUserId.isSuccess()) {
        UIHelper.showToast(msg: childUserId.error);
        debugPrint('HERE IS IT ERROR ${childUserId.error}');
        return false;
      }
      await identityService.setParentId(parentId);
      await identityService.setUserId(childUserId.data!);
      await identityService.setPoolAccountId('');
      return true;
    } else
      UIHelper.showToast(msg: response.error);
    return false;
  }

  void setParentId(String parentId) {
    this.parentId = parentId;
    notifyListeners();
  }
}
