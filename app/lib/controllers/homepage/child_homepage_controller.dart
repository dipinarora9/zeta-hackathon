import 'package:flutter/cupertino.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/services/database_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

class ChildHomepageController with ChangeNotifier {
  final DatabaseService databaseService;
  final IdentityService identityService;

  ChildHomepageController(this.databaseService, this.identityService);

  initialize() {
    fetchChildDetails();
    fetchAnalytics();
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
}
