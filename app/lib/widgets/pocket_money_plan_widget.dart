import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/pocket_money_plan_controller.dart';
import 'package:zeta_hackathon/models/pocket_money.dart';

import 'pocket_money_plan_detail.dart';

class PocketMoneyPlanWidget extends StatelessWidget {
  const PocketMoneyPlanWidget({Key? key, required this.plan}) : super(key: key);
  final PocketMoney plan;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(r"$ " + plan.amount.toString()),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Amount'),
                      Text(plan.amount.toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Recurring Days'),
                      Text(plan.recurringDays.toString()),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
                PocketMoney? res = await showDialog<PocketMoney?>(
                  context: context,
                  builder: (context) => Dialog(
                    child: SingleChildScrollView(
                      child: PocketMoneyPlanDetailWidget(
                        plan: plan,
                      ),
                    ),
                  ),
                );
                if (res != null)
                  context.read<PocketMoneyPlanController>().savePlan(res);
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ],
    );
  }
}
