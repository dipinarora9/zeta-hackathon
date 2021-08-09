import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/services/database_service.dart';

class ChildrenController {
  final Child child;
  final DatabaseService databaseService;

  ChildrenController(this.child, this.databaseService);

  saveChild() async {
    AppResponse<bool> response = await databaseService.addChildDetails(child);
    if (response.isSuccess())
      UIHelper.showToast(msg: 'Saved');
    else
      UIHelper.showToast(msg: response.error);
  }

  deleteChild() async {
    AppResponse<bool> response =
        await databaseService.deleteChildDetails(child);
    if (response.isSuccess())
      UIHelper.showToast(msg: 'Deleted');
    else
      UIHelper.showToast(msg: response.error);
  }
}
