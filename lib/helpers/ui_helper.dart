import 'package:fluttertoast/fluttertoast.dart';

class UIHelper {
  static showToast(
      {required String? msg, String? webBgColor, int? timeInSecForWeb}) {
    if (msg != null)
      Fluttertoast.showToast(
        msg: msg,
        webBgColor: webBgColor ?? "linear-gradient(to right, #2a2e45, #2a2e45)",
        timeInSecForIosWeb: timeInSecForWeb ?? 5,
      );
  }
}
