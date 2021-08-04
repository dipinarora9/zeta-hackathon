import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/models/user/child.dart';

import './database_service.dart';

class TransactionService {
  final DatabaseService databaseService = DatabaseService();
  createTransaction(Transaction transaction, Child child) {
    try {
      if (child.balance >= transaction.amount) {
        Child newChild = Child(
            balance: child.balance - transaction.amount,
            paymentPermissionRequired: child.paymentPermissionRequired,
            parentId: child.parentId,
            userId: child.userId,
            createdDate: child.createdDate,
            aadhaarNumber: child.aadhaarNumber,
            isParent: child.isParent,
            username: child.username,
            email: child.email);
        databaseService.updateChildDetails(newChild);
      } else {
        throw Exception();
      }
    } catch (e) {}
  }
}
