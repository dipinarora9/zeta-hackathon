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
  Child? _child;

  ChildHomepageController(
    this.databaseService,
    this.identityService,
    this.authenticationService,
    this.scannerService,
  );

  Child? get child => _child;

  initialize() {
    fetchChildDetails();
    fetchAnalytics();
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

  Future<void> fetchChildDetails() async {
    AppResponse<Child> response = await databaseService.fetchChildDetails(
        identityService.getParentId()!, identityService.getUID());
    if (response.isSuccess()) {
      _child = response.data!;
      notifyListeners();
    } else {
      debugPrint("HERE IS IT ${response.error}");
      UIHelper.showToast(msg: response.error);
    }
    return;
  }

  void fetchAnalytics() {}

  void logout(BuildContext context) async {
    await authenticationService.signOut();
    identityService.removeParentId();
    identityService.removeUserId();
    Navigator.of(context).pushReplacementNamed(Routes.initialScreen);
  }
}
