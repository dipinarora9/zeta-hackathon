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
      if (FirebaseAuth.instance.currentUser != null)
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(parent.username);
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      print("HERE IS IT error ${e.message}");
      return AppResponse(error: e.message);
    } catch (e) {
      print("HERE IS IT error $e");
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> updateLatestRenewalDateToTomorrow(
      String parentID) async {
    try {
      DateTime d = DateTime.now().toUtc().add(Duration(days: 1));
      int timestamp =
          (DateTime(d.year, d.month, d.day).millisecondsSinceEpoch ~/ 1000)
              .toInt();
      await parentCollection
          .doc(parentID)
          .update({'latest_renewal_date': timestamp});
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      print("HERE IS IT error ${e.message}");
      return AppResponse(error: e.message);
    } catch (e) {
      print("HERE IS IT error $e");
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<Parent>> fetchParentDetails({String? uid}) async {
    try {
      DocumentSnapshot snapshot = await parentCollection
          .doc(uid ?? FirebaseAuth.instance.currentUser!.uid)
          .get();
      Parent parent = snapshot.data() as Parent;
      return AppResponse(data: parent);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<String>> fetchChildDetailsUsingEmail(
      String parentId, String email) async {
    try {
      QuerySnapshot snapshot = await parentCollection
          .doc(parentId)
          .collection('children')
          .where('email', isEqualTo: email)
          .get();

      return AppResponse(data: snapshot.docs.first['user_id']);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<String>> addChildDetails(Child child) async {
    try {
      String userId = child.userId;
      if (userId == '') {
        var ref = await childCollection(child.parentId).add(child);
        child = child.copyWith(userId: ref.id);
        userId = ref.id;
      }
      await childCollection(child.parentId).doc(userId).set(child);
      QuerySnapshot s = await childCollection(child.parentId)
          .orderBy('pocket_money_details.renewal_date')
          .limit(1)
          .get();
      int latestRenewal = double.maxFinite.toInt();
      if (s.docs.length > 0) {
        Child c = s.docs[0].data() as Child;
        latestRenewal =
            c.pocketMoneyDetails?.renewalDate ?? double.maxFinite.toInt();
      }
      await parentCollection.doc(child.parentId).update({
        'children_ids': FieldValue.arrayUnion([child.userId]),
        'latest_renewal_date': latestRenewal,
      });
      return AppResponse(data: userId);
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
      if (snapshot.exists) {
        Child child = snapshot.data() as Child;
        return AppResponse(data: child);
      } else
        throw Exception(
            'Child doesn\'t exist - PID = $parentID CID - $childID');
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
      await parentCollection.doc(child.parentId).update({
        'children_ids': FieldValue.arrayRemove([child.userId])
      });
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

  Future<AppResponse<bool>> updateBalance(Child child, double amount) async {
    try {
      await childCollection(child.parentId)
          .doc(child.userId)
          .update({'balance': FieldValue.increment(amount)});
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
      pocketMoney = pocketMoney.copyWith(
        parentId: FirebaseAuth.instance.currentUser!.uid,
      );
      String planId = pocketMoney.planId;
      if (planId == '') {
        var ref =
            await pocketMoneyCollection(pocketMoney.parentId).add(pocketMoney);
        planId = ref.id;
      }
      await pocketMoneyCollection(pocketMoney.parentId)
          .doc(planId)
          .update(pocketMoney.copyWith(planId: planId).toJson());
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
