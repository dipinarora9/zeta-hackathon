import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/user/parent.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/cloud_functions_service.dart';
import 'package:zeta_hackathon/services/database_service.dart';

class SignUpController with ChangeNotifier {
  final AuthenticationService authenticationService;
  final DatabaseService databaseService;
  final CloudFunctionsService cloudFunctionsService;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController panController;
  final TextEditingController usernameController;

  final TextEditingController mobileController;
  DateTime _dob;

  SignUpController(this.authenticationService, this.databaseService,
      this.cloudFunctionsService)
      : emailController = TextEditingController(text: 'a@f.com'),
        passwordController = TextEditingController(text: '1234567'),
        panController = TextEditingController(text: '12345'),
        usernameController = TextEditingController(text: 'abc'),
        mobileController = TextEditingController(text: '987654'),
        _dob = DateTime(1970, 4, 1);

  signUp() async {
    AppResponse<String> signUpResponse = await authenticationService.signUp(
        emailController.text, passwordController.text);
    if (!signUpResponse.isSuccess()) {
      debugPrint('HERE IS IT error ${signUpResponse.error}');
      UIHelper.showToast(msg: signUpResponse.error);
      return;
    }
    Parent parent = Parent(
      accountNumber: '',
      poolAccountId: '',
      childrenIds: [],
      individualId: '',
      mobile: int.parse(mobileController.text),
      userId: signUpResponse.data!,
      createdDate: DateTime.now().toUtc().millisecondsSinceEpoch,
      pan: panController.text,
      isParent: true,
      username: usernameController.text,
      email: emailController.text,
      dob: _dob,
    );

    AppResponse<Parent> fusionResponse =
        await cloudFunctionsService.signUpParent(parent);
    if (!fusionResponse.isSuccess()) {
      debugPrint('HERE IS IT ${fusionResponse.error}');
      UIHelper.showToast(msg: fusionResponse.error);
      return;
    }
    parent = fusionResponse.data!;
    AppResponse<bool> databaseResponse =
        await databaseService.saveParentDetails(parent);
    if (databaseResponse.isSuccess())
      UIHelper.showToast(msg: 'Sign Up Success');
    else {
      debugPrint('HERE IS IT error ${databaseResponse.error}');
      UIHelper.showToast(msg: databaseResponse.error);
    }
  }

  setDate(DateTime date) {
    _dob = date;
  }
}
