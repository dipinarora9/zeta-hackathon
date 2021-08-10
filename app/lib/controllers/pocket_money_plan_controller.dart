import 'package:flutter/foundation.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/pocket_money.dart';
import 'package:zeta_hackathon/services/database_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

class PocketMoneyPlanController with ChangeNotifier {
  final DatabaseService databaseService;
  final IdentityService identityService;
  Map<String, PocketMoney> _plans;

  PocketMoneyPlanController(this.databaseService, this.identityService)
      : this._plans = Map();

  Map<String, PocketMoney> get plans => _plans;

  initialize() {
    fetchPlans();
  }

  abc() {}

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

  updatePlan(PocketMoney plan) async {
    AppResponse<bool> response =
        await databaseService.addPocketMoneyPlanDetails(plan);
    if (response.isSuccess()) {
      _plans[plan.planId] = plan;
      notifyListeners();
    } else
      UIHelper.showToast(msg: response.error);
  }

  deletePlan(PocketMoney plan) async {
    AppResponse<bool> response =
        await databaseService.deletePocketMoneyPlanDetails(plan);
    if (response.isSuccess()) {
      _plans.remove(plan.planId);
      notifyListeners();
    } else
      UIHelper.showToast(msg: response.error);
  }
}
