import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/models/user/parent.dart';

class CloudFunctionsService {
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<AppResponse<Parent>> signUpParent(Parent parent) async {
    try {
      HttpsCallable callable = functions.httpsCallable('ParentSignUp');

      final results = await callable(parent.toFusionAPIJson());
      print(results.data);
      //todo: add account number
      return AppResponse(data: parent.copyWith(accountNumber: 123));
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<Child>> signUpChild(Child child) async {
    try {
      HttpsCallable callable = functions.httpsCallable('ChildSignUp');

      final results = await callable(child.toFusionAPIJson());
      print(results.data);
      return AppResponse(data: child);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<double>> checkBalance(String accountID) async {
    try {
      HttpsCallable callable = functions.httpsCallable('checkBalance');

      final results = await callable(accountID);
      print(results.data);
      //todo: add amount
      return AppResponse(data: 123);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> doTransaction(Transaction transaction) async {
    try {
      HttpsCallable callable = functions.httpsCallable('A2ATransaction');

      final results = await callable(transaction.toFusionAPIJson());
      print(results.data);
      //todo: add response
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> getAccountDetails(String individualID) async {
    try {
      HttpsCallable callable = functions.httpsCallable('getAccountDetails');

      final results = await callable(individualID);
      print(results.data);
      //todo: add response
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
