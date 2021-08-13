import 'package:flutter/cupertino.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/database_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';
import 'package:zeta_hackathon/services/scanner_service.dart';

import '../../routes.dart';

class ChildHomepageController with ChangeNotifier {
  final DatabaseService databaseService;
  final AuthenticationService authenticationService;
  final IdentityService identityService;
  final ScannerService scannerService;

  ChildHomepageController(
    this.databaseService,
    this.identityService,
    this.authenticationService,
    this.scannerService,
  );

  initialize({String? parentId}) {
    fetchChildDetails();
    fetchAnalytics();
    if (parentId != null) identityService.setParentId(parentId);
  }

  scanQR(BuildContext context) async {
    AppResponse<UserObject> response = await scannerService.scannerService();
    if (response.isSuccess()) {
      Navigator.of(context)
          .pushNamed(Routes.transactionScreen, arguments: response.data!);
    } else
      UIHelper.showToast(msg: response.error);
  }

  generateQR(BuildContext context) async {
    AppResponse<String> response = await scannerService.generateQR();
    if (response.isSuccess()) {
      Navigator.of(context)
          .pushNamed(Routes.qrScreen, arguments: response.data!);
    } else
      UIHelper.showToast(msg: response.error);
  }

  void fetchChildDetails() async {
    AppResponse<Child> response = await databaseService.fetchChildDetails(
        identityService.getParentId()!, identityService.getUID());
    if (response.isSuccess()) {
      notifyListeners();
    } else
      UIHelper.showToast(msg: response.error);
  }

  void fetchAnalytics() {}

  void logout(BuildContext context) async {
    await authenticationService.signOut();
    identityService.removeParentId();
    Navigator.of(context).pushReplacementNamed(Routes.initialScreen);
  }
}
