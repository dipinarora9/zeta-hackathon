import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/models/pocket_money.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/models/user/parent.dart';

class DatabaseService {
  final CollectionReference<Parent> parentCollection =
      FirebaseFirestore.instance.collection('users').withConverter<Parent>(
            fromFirestore: (snapshot, _) => Parent.fromJson(snapshot.data()!),
            toFirestore: (parent, _) => parent.toJson(),
          );

  CollectionReference childCollection(String parentId) => parentCollection
      .doc(parentId)
      .collection('children')
      .withConverter<Child>(
        fromFirestore: (snapshot, _) => Child.fromJson(snapshot.data()!),
        toFirestore: (child, _) => child.toJson(),
      );

  CollectionReference pocketMoneyCollection(String parentId) => parentCollection
      .doc(parentId)
      .collection('pocket_money_plans')
      .withConverter<PocketMoney>(
        fromFirestore: (snapshot, _) => PocketMoney.fromJson(snapshot.data()!),
        toFirestore: (parent, _) => parent.toJson(),
      );

  Future<AppResponse<bool>> saveParentDetails(Parent parent) async {
    try {
      await parentCollection.doc(parent.userId).set(parent);
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<Parent>> fetchParentDetails() async {
    try {
      DocumentSnapshot snapshot = await parentCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Parent parent = Parent.fromJson(snapshot.data() as Map<String, dynamic>);
      return AppResponse(data: parent);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<String>> addChildDetails(Child child) async {
    try {
      var ref = await childCollection(child.parentId).add(child);
      child = child.copyWith(userId: ref.id);
      await childCollection(child.parentId).add(child);
      return AppResponse(data: ref.id);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<Child>> fetchChildDetails(
      String parentID, String childID) async {
    try {
      DocumentSnapshot snapshot =
          await childCollection(parentID).doc(childID).get();
      Child child = Child.fromJson(snapshot.data() as Map<String, dynamic>);
      return AppResponse(data: child);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<Map<String, Child>>> fetchChildren(String parentId) async {
    try {
      var snapshot = await childCollection(parentId).get();
      Map<String, Child> childData = Map();
      snapshot.docs.forEach((element) {
        Child c = element.data() as Child;
        childData[c.userId] = c;
      });
      return AppResponse(data: childData);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> deleteChildDetails(Child child) async {
    try {
      await childCollection(child.parentId).doc(child.userId).delete();
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> updateChildDetails(Child child) async {
    try {
      await childCollection(child.parentId)
          .doc(child.userId)
          .update(child.toJson());
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> addPocketMoneyPlanDetails(
      PocketMoney pocketMoney) async {
    try {
      var ref =
          await pocketMoneyCollection(pocketMoney.parentId).add(pocketMoney);
      await pocketMoneyCollection(pocketMoney.parentId)
          .doc(ref.id)
          .update(pocketMoney.copyWith(planId: ref.id).toJson());
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<Map<String, PocketMoney>>> fetchPocketMoneyDetails(
      String parentId) async {
    try {
      var snapshot = await pocketMoneyCollection(parentId).get();
      Map<String, PocketMoney> pocketMoneyData = Map();
      snapshot.docs.forEach((element) {
        PocketMoney c = element.data() as PocketMoney;
        pocketMoneyData[c.planId] = c;
      });
      return AppResponse(data: pocketMoneyData);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> updatePocketMoneyPlanDetails(
      PocketMoney pocketMoney) async {
    try {
      await pocketMoneyCollection(pocketMoney.parentId)
          .doc(pocketMoney.planId)
          .update(pocketMoney.toJson());
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> deletePocketMoneyPlanDetails(
      PocketMoney pocketMoney) async {
    try {
      await pocketMoneyCollection(pocketMoney.parentId)
          .doc(pocketMoney.planId)
          .delete();
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
