import 'package:flutter/cupertino.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';
import 'package:zeta_hackathon/services/transaction_service.dart';

class TransactionController with ChangeNotifier {
  final TransactionService transactionService;
  final IdentityService identityService;
  UserObject receiver;

  TransactionController(
      this.receiver, this.transactionService, this.identityService);

  sendMoney(BuildContext context, double amount) async {
    AppResponse<bool> response =
        await transactionService.createTransaction(amount, receiver);
    if (response.isSuccess()) {
      UIHelper.showToast(msg: 'Paid successfully!');
      Navigator.of(context).pop();
    } else
      UIHelper.showToast(msg: response.error);
  }
}
