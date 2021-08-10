import 'package:flutter/cupertino.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/routes.dart';
import 'package:zeta_hackathon/services/analytics_service.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/database_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

class ParentHomepageController with ChangeNotifier {
  final DatabaseService databaseService;
  final AnalyticsService analyticsService;
  final AuthenticationService authenticationService;
  final IdentityService identityService;
  Map<String, Child> _children;

  ParentHomepageController(this.databaseService, this.analyticsService,
      this.identityService, this.authenticationService)
      : _children = Map();

  Map<String, Child> get children => _children;

  initialize() {
    fetchChildren();
    fetchAnalytics();
  }

  Future<void> fetchChildren() async {
    AppResponse<Map<String, Child>> response =
        await databaseService.fetchChildren(identityService.getUID());
    if (response.isSuccess()) {
      response.data!.forEach((key, value) {
        _children[key] = value;
      });
      notifyListeners();
    } else
      UIHelper.showToast(msg: response.error);
    return;
  }

  void fetchAnalytics() {}

  void logout(BuildContext context) async {
    await authenticationService.signOut();
    Navigator.of(context).pushReplacementNamed(Routes.initialScreen);
  }
}
