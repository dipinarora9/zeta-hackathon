import 'package:flutter/material.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class AllowPaymentScreen extends StatelessWidget {
  const AllowPaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Allow Payment?',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 55,
                color: Colors.black,
              ),
            ),
          ),
          CustomButton(onPressed: () {}, text: 'Allow'),
        ],
      ),
    );
  }
}
