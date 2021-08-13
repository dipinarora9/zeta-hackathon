import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({Key? key, required this.data}) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: Container(
          child: QrImage(data: data),
          width: MediaQuery.of(context).size.width / 1.3,
        ),
      ),
      title: 'QR Code',
    );
  }
}
