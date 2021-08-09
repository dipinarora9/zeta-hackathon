import 'package:flutter/cupertino.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';
import 'package:zeta_hackathon/services/transaction_service.dart';

class TransactionController with ChangeNotifier {
  final TransactionService transactionService;
  final IdentityService identityService;

  TransactionController(this.transactionService, this.identityService);

  sendMoney(double amount, UserObject receiver) async {
    AppResponse<bool> response =
        await transactionService.createTransaction(amount, receiver);
    if (response.isSuccess()) {
      UIHelper.showToast(msg: 'Paid successfully!');
      //pop out of screen
    } else
      UIHelper.showToast(msg: response.error);
  }
}
