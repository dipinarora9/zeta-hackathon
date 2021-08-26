import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';

import '../dependency_injector.dart';
import 'identitiy_service.dart';

class AuthenticationService {
  Future<AppResponse<String>> loginAsParent(
      String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user == null) throw Exception("Could not log you in");
      return AppResponse(data: credential.user!.uid);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> loginAsChild(String email, String emailLink) async {
    try {
      var auth = FirebaseAuth.instance;
      var emailAuth = email;
      if (auth.isSignInWithEmailLink(emailLink)) {
        UserCredential userCredential = await auth.signInWithEmailLink(
            email: emailAuth, emailLink: emailLink);

        // You can access the new user via value.user
        // Additional user info profile *not* available via:
        // value.additionalUserInfo.profile == null
        // You can check if the user is new or existing:
        // value.additionalUserInfo.isNewUser;

        return AppResponse(data: true);
      } else
        throw Exception('Invalid Link');
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> loginUsingOOBCode(String actionCode) async {
    try {
      var auth = FirebaseAuth.instance;

      await auth.checkActionCode(actionCode);
      await auth.applyActionCode(actionCode);

      // If successful, reload the user:
      await auth.currentUser?.reload();
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      print('HERE IS IT error ${e.message}');
      return AppResponse(error: e.message);
    } catch (e, st) {
      print('HERE IS IT error $e \n$st');
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<String>> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return AppResponse(data: userCredential.user!.uid);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> sendLoginLinkToChild(
      String email, String childId) async {
    try {
      IdentityService identityService = sl<IdentityService>();

      var acs = ActionCodeSettings(
          url:
              'https://zetahackdipinprashant.page.link?email=$email&child_id=$childId&parent_id=${FirebaseAuth.instance.currentUser!.uid}&pool_account_id=${identityService.getPoolAccountId()}',
          handleCodeInApp: true,
          androidPackageName: 'com.example.zeta_hackathon',
          androidMinimumVersion: '16',
          dynamicLinkDomain: 'zetahackdipinprashant.page.link');
      await FirebaseAuth.instance
          .sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
