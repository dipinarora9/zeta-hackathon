import 'package:flutter/foundation.dart';
import 'package:zeta_hackathon/services/database_service.dart';

class PocketMoneyPlanController with ChangeNotifier {
  final DatabaseService databaseService;

  PocketMoneyPlanController(this.databaseService);

  initialize() {
    fetchPlans();
  }

  void fetchPlans() {}

  updatePlan() {}
}
