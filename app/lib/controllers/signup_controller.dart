import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/user/parent.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/database_service.dart';

class SignUpController with ChangeNotifier {
  final AuthenticationService authenticationService;
  final DatabaseService databaseService;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController aadhaarController;
  final TextEditingController usernameController;
  final TextEditingController accountController;
  final TextEditingController mobileController;

  SignUpController(this.authenticationService, this.databaseService)
      : emailController = TextEditingController(),
        passwordController = TextEditingController(),
        aadhaarController = TextEditingController(),
        usernameController = TextEditingController(),
        accountController = TextEditingController(),
        mobileController = TextEditingController();

  signUp() async {
    AppResponse<String> signUpResponse = await authenticationService.signUp(
        emailController.text, passwordController.text);
    if (!signUpResponse.isSuccess()) {
      UIHelper.showToast(msg: signUpResponse.error);
      return;
    }
    Parent parent = Parent(
        accountNumber: int.parse(accountController.text),
        childrenIds: [],
        mobile: int.parse(mobileController.text),
        userId: signUpResponse.data!,
        createdDate: DateTime.now().toUtc().millisecondsSinceEpoch,
        aadhaarNumber: int.parse(aadhaarController.text),
        isParent: true,
        username: usernameController.text,
        email: emailController.text);

    AppResponse<bool> databaseResponse =
        await databaseService.saveParentDetails(parent);
    if (databaseResponse.isSuccess())
      UIHelper.showToast(msg: 'Sign Up Success');
    else
      UIHelper.showToast(msg: databaseResponse.error);
  }
}
