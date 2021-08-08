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

  Future<AppResponse<bool>> loginAsChild(String email) async {
    try {
      // FirebaseAuth.instance.signInWithEmailLink(email: email, emailLink: emailLink);
      return AppResponse(data: true);
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
      return AppResponse(data: true);
    } on FirebaseException catch (e) {
      return AppResponse(error: e.message);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
