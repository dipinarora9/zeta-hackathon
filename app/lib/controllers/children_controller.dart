import 'package:flutter/widgets.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/database_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

class ChildrenController {
  Child child;
  final DatabaseService databaseService;
  final IdentityService identityService;
  final AuthenticationService authenticationService;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController aadhaarController;
  ChildrenController(this.child, this.authenticationService,
      this.databaseService, this.identityService)
      : emailController = TextEditingController(),
        aadhaarController = TextEditingController(),
        usernameController = TextEditingController();

  saveChild() async {
    if (child.userId == "") {
      AppResponse<bool> signUpResponse = await authenticationService
          .sendLoginLinkToChild(emailController.text);
      if (!signUpResponse.isSuccess()) {
        UIHelper.showToast(msg: signUpResponse.error);
        return;
      }
      child = child.copyWith(
          createdDate: DateTime.now().toUtc().millisecondsSinceEpoch,
          aadhaarNumber: int.parse(aadhaarController.text),
          isParent: false,
          username: usernameController.text,
          email: emailController.text,
          paymentPermissionRequired: false,
          parentId: identityService.getUID(),
          balance: 0);
    }
    AppResponse<String> response = await databaseService.addChildDetails(child);
    if (response.isSuccess()) {
      child = child.copyWith(userId: response.data);
      UIHelper.showToast(msg: 'Saved');
    } else
      UIHelper.showToast(msg: response.error);
  }

  deleteChild() async {
    AppResponse<bool> response =
        await databaseService.deleteChildDetails(child);
    if (response.isSuccess())
      UIHelper.showToast(msg: 'Deleted');
    else
      UIHelper.showToast(msg: response.error);
  }
}
