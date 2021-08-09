import 'package:flutter/material.dart';

class QRWidget extends StatelessWidget {
  const QRWidget({Key? key, required this.data}) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return QRWidget(data: data);
  }
}
