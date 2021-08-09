import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/models/transaction.dart';

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
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<String>> generateQR() async {
    try {
      if (FirebaseAuth.instance.currentUser == null)
        throw Exception('Please sign in to use this feature');
      UserObject userObject = UserObject(
          name: FirebaseAuth.instance.currentUser!.displayName ?? 'No name',
          id: FirebaseAuth.instance.currentUser!.uid);
      return AppResponse(data: userObject.toString());
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
