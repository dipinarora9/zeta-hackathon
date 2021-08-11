import 'package:flutter/cupertino.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';
import 'package:zeta_hackathon/services/scanner_service.dart';
import 'package:zeta_hackathon/services/transaction_service.dart';

class TransactionController with ChangeNotifier {
  final TransactionService transactionService;
  final IdentityService identityService;
  final ScannerService scannerService;
  UserObject? receiver;

  TransactionController(
      this.transactionService, this.identityService, this.scannerService);

  scanQR(BuildContext context, double amount, UserObject receiver) async {
    AppResponse<UserObject> response = await scannerService.scannerService();
    if (response.isSuccess()) {
      receiver = response.data!;
    } else
      UIHelper.showToast(msg: response.error);
  }

  sendMoney(BuildContext context, double amount) async {
    if (receiver == null) {
      UIHelper.showToast(msg: 'No receiver found');
      return;
    }
    AppResponse<bool> response =
        await transactionService.createTransaction(amount, receiver!);
    if (response.isSuccess()) {
      UIHelper.showToast(msg: 'Paid successfully!');
      Navigator.of(context).pop();
    } else
      UIHelper.showToast(msg: response.error);
  }
}
