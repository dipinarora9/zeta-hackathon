import 'package:flutter/material.dart';
import 'package:zeta_hackathon/models/user/child.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({Key? key, required this.child}) : super(key: key);
  final Child child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Balance: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '\$ ${child.balance}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        if (child.pocketMoneyDetails != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Balance Renewal Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${DateTime.fromMillisecondsSinceEpoch(child.pocketMoneyDetails!.renewalDate).toLocal()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        SizedBox(height: 30),
      ],
    );
  }
}
