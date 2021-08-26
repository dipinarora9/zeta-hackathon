import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

import './database_service.dart';

class TransactionService {
  final DatabaseService databaseService;
  final IdentityService identityService;

  TransactionService(this.databaseService, this.identityService);

  Future<AppResponse<Transaction>> createTransaction(
      double amount, UserObject receiver) async {
    try {
      //fetch senderChild
      AppResponse<Child> childResponse =
          await databaseService.fetchChildDetails(
              identityService.getParentId()!, identityService.getUID());
      if (!childResponse.isSuccess()) throw Exception('Not logged in');
      Child senderChild = childResponse.data!;
      if (senderChild.balance >= amount) {
        senderChild =
            senderChild.copyWith(balance: senderChild.balance - amount);
        //store transaction in database
        Transaction transaction = Transaction(
          amount: amount,
          transactionId: '1234',
          receiver: receiver,
          sender: senderChild.toUserObject(),
          accountHolderId: senderChild.parentId,
          timestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
        );

        ///todo: Store transaction in realtime db
        Child receiverChild = Child.empty();
        receiverChild = receiverChild.copyWith(
            parentId: receiver.parentId, userId: receiver.id);
        AppResponse<bool> senderResponse =
            await databaseService.updateBalance(senderChild, -amount);
        if (!senderResponse.isSuccess()) throw Exception(senderResponse.error);
        AppResponse<bool> receiverResponse =
            await databaseService.updateBalance(receiverChild, amount);
        if (!receiverResponse.isSuccess())
          throw Exception(receiverResponse.error);
        return AppResponse(data: transaction);
      } else {
        throw Exception("Insufficient Balance");
      }
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
