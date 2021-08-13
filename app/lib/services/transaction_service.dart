import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

import './database_service.dart';

class TransactionService {
  final DatabaseService databaseService;
  final IdentityService identityService;

  TransactionService(this.databaseService, this.identityService);

  Future<AppResponse<bool>> createTransaction(
      double amount, UserObject receiver) async {
    try {
      //fetch child
      AppResponse<Child> childResponse =
          await databaseService.fetchChildDetails(
              identityService.getParentId()!, identityService.getUID());
      if (!childResponse.isSuccess()) throw Exception('Not logged in');
      Child child = childResponse.data!;
      if (child.balance >= amount) {
        child = child.copyWith(balance: child.balance - amount);
        //store transaction in database
        Transaction transaction = Transaction(
          amount: amount,
          transactionId: '1234',
          receiver: receiver,
          sender: child.toUserObject(),
          accountHolderId: child.parentId,
          timestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
        );
        ///todo: Store transaction in realtime db

        return await databaseService.updateChildDetails(child);
      } else {
        throw Exception("Insufficient Balance");
      }
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
