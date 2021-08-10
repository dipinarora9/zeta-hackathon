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
      : emailController = TextEditingController(text: child.email),
        aadhaarController =
            TextEditingController(text: child.aadhaarNumber.toString()),
        usernameController = TextEditingController(text: child.username);

  saveChild(BuildContext context) async {
    if (child.userId == "") {
      AppResponse<bool> signUpResponse = await authenticationService
          .sendLoginLinkToChild(emailController.text);
      if (!signUpResponse.isSuccess()) {
        debugPrint(signUpResponse.error);
        UIHelper.showToast(msg: signUpResponse.error);
        return;
      } else
        UIHelper.showToast(msg: 'Invite sent!');
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
      Navigator.of(context).pop();
    } else
      UIHelper.showToast(msg: response.error);
  }

  resendInvite() async {
    AppResponse<bool> signUpResponse =
        await authenticationService.sendLoginLinkToChild(emailController.text);
    if (!signUpResponse.isSuccess()) {
      debugPrint(signUpResponse.error);
      UIHelper.showToast(msg: signUpResponse.error);
      return;
    } else
      UIHelper.showToast(msg: 'Invite sent!');
  }

  deleteChild(BuildContext context) async {
    AppResponse<bool> response =
        await databaseService.deleteChildDetails(child);
    if (response.isSuccess()) {
      Navigator.of(context).pop();
      UIHelper.showToast(msg: 'Deleted');
    } else
      UIHelper.showToast(msg: response.error);
  }
}
