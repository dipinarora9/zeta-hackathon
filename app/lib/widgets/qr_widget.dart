import 'package:flutter/material.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class QRWidget extends StatelessWidget {
  const QRWidget({Key? key, required this.data}) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: QRWidget(data: data),
      title: 'QR Code',
    );
  }
}
