import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:zeta_hackathon/dependency_injector.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

class ScannerService {
  Future<AppResponse<UserObject>> scannerService() async {
    try {
      String colorCode = '#0000CD';
      String cancelButtonText = 'Cancel';
      bool isFlashAllowed = true;
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          colorCode, cancelButtonText, isFlashAllowed, ScanMode.QR);

      UserObject user = UserObject.fromJson(jsonDecode(barcodeScanRes));
      return AppResponse(data: user);
    } catch (e, st) {
      print("HERE IS IT $e \n$st");
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<String>> generateQR() async {
    try {
      if (FirebaseAuth.instance.currentUser == null)
        throw Exception('Please sign in to use this feature');

      IdentityService identityService = sl<IdentityService>();
      UserObject userObject = UserObject(
        name: identityService.getName(),
        id: identityService.getUID(),
        parentId: identityService.getParentId()!,
        accountId: identityService.getPoolAccountId()!,
      );
      return AppResponse(data: jsonEncode(userObject.toJson()));
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
