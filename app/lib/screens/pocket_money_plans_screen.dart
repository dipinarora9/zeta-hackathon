import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/pocket_money_plan_controller.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';
import 'package:zeta_hackathon/widgets/pocket_money_plan_widget.dart';

class PocketMoneyPlanScreen extends StatelessWidget {
  const PocketMoneyPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Pocket Money Plans',
      body: Consumer<PocketMoneyPlanController>(builder: (_, value, __) {
        return ListView.builder(
          itemBuilder: (context, index) => PocketMoneyPlanWidget(
            plan: value.plans.values.toList()[index],
          ),
          itemCount: 1,
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => context.read<PocketMoneyPlanController>(),
      ),
    );
  }
}
