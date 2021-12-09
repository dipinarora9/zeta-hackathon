import 'package:flutter/cupertino.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/routes.dart';
import 'package:zeta_hackathon/services/cloud_functions_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';
import 'package:zeta_hackathon/services/transaction_service.dart';

class TransactionController with ChangeNotifier {
  final TransactionService transactionService;
  final IdentityService identityService;
  final CloudFunctionsService cloudFunctionsService;

  final TextEditingController amountController;

  UserObject receiver;

  TransactionController(this.receiver, this.transactionService,
      this.identityService, this.cloudFunctionsService)
      : amountController = TextEditingController(text: '0');

  sendMoney(BuildContext context) async {
    if (double.tryParse(amountController.text) == null) {
      UIHelper.showToast(msg: 'Please enter amount correctly.');
      return;
    }
    if (double.parse(amountController.text) <= 0) {
      UIHelper.showToast(msg: 'Amount should be greater than 0');
      return;
    }

    AppResponse<Transaction> response = await transactionService
        .createTransaction(double.parse(amountController.text), receiver);
    if (!response.isSuccess()) {
      UIHelper.showToast(msg: response.error);
      return;
    }

    UIHelper.showToast(msg: 'Paid successfully!');
    Navigator.of(context).pushReplacementNamed(Routes.homepageChild);
  }
}
