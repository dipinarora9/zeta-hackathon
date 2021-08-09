import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/models/user/child.dart';

class AuthenticationService {
  Future<AppResponse<String>> loginAsParent() async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInAnonymously();
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
      var emailAuth = 'someemail@domain.com';
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

  Future<AppResponse<bool>> signUp(String email, String password) async {
    try {
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> sendLoginLinkToChild(Child child) async {
    try {
      var acs = ActionCodeSettings(
          url: 'https://zetahackdipinprashant.page.link',
          handleCodeInApp: true,
          androidPackageName: 'com.example.zeta_hackathon',
          androidMinimumVersion: '16');
      await FirebaseAuth.instance
          .sendSignInLinkToEmail(email: child.email, actionCodeSettings: acs);
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}