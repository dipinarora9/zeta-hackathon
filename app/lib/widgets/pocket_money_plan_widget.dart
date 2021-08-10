import 'package:flutter/material.dart';
import 'package:zeta_hackathon/models/pocket_money.dart';

class PocketMoneyPlanWidget extends StatelessWidget {
  const PocketMoneyPlanWidget({Key? key, required this.plan}) : super(key: key);
  final PocketMoney plan;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(r"$ " + plan.amount.toString()),
      children: [],
    );
  }
}
