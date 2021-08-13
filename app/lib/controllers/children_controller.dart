import 'package:flutter/widgets.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/pocket_money.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/database_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

class ChildrenController with ChangeNotifier {
  Child child;
  final DatabaseService databaseService;
  final IdentityService identityService;
  final AuthenticationService authenticationService;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController aadhaarController;
  String? _currentSelectedPlan;
  bool _permissionRequired;
  Map<String, PocketMoney> _plans;

  ChildrenController(this.child, this.authenticationService,
      this.databaseService, this.identityService)
      : emailController = TextEditingController(text: child.email),
        aadhaarController =
            TextEditingController(text: child.aadhaarNumber.toString()),
        usernameController = TextEditingController(text: child.username),
        _currentSelectedPlan = child.pocketMoneyDetails?.pocketMoneyPlanId,
        _permissionRequired = child.paymentPermissionRequired,
        this._plans = Map();

  Map<String, PocketMoney> get plans => _plans;

  String? get currentSelectedPlan => _currentSelectedPlan;

  bool get permissionRequired => _permissionRequired;

  initialize() {
    fetchPlans();
  }

  void fetchPlans() async {
    AppResponse<Map<String, PocketMoney>> response =
        await databaseService.fetchPocketMoneyDetails(identityService.getUID());
    if (response.isSuccess()) {
      response.data!.forEach((key, value) {
        _plans[key] = value;
      });
      notifyListeners();
    } else
      UIHelper.showToast(msg: response.error);
  }

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
      DateTime d = DateTime.now().toUtc();
      child = child.copyWith(
        createdDate: DateTime(d.year, d.month, d.day).millisecondsSinceEpoch,
        aadhaarNumber: int.parse(aadhaarController.text),
        isParent: false,
        username: usernameController.text,
        email: emailController.text,
        paymentPermissionRequired: _permissionRequired,
        parentId: identityService.getUID(),
        balance: 0,
      );
    }
    child = child.copyWith(
      aadhaarNumber: int.parse(aadhaarController.text),
      username: usernameController.text,
      email: emailController.text,
      paymentPermissionRequired: _permissionRequired,
    );
    AppResponse<String> response = await databaseService.addChildDetails(child);
    if (response.isSuccess()) {
      child = child.copyWith(userId: response.data);
      notifyListeners();
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

  setPlan(String? plan) async {
    _currentSelectedPlan = plan;
    if (plan != null) {
      DateTime d = DateTime.now().toUtc();
      child = child.copyWith(
        pocketMoneyDetails: child.pocketMoneyDetails?.copyWith(
              pocketMoneyPlanId: plan,
            ) ??
            PocketMoneyDetails(
              renewalDate:
                  (DateTime(d.year, d.month, d.day).millisecondsSinceEpoch ~/
                          1000)
                      .toInt(),
              pocketMoneyPlanId: plan,
            ),
      );
    }
    notifyListeners();
  }

  setPermission(bool required) async {
    _permissionRequired = required;
    notifyListeners();
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
