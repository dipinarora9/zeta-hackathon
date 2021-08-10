import 'package:flutter/material.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class PocketMoneyPlanScreen extends StatelessWidget {
  const PocketMoneyPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Pocket Money Plans',
      body: Container(),
      // body: ListView.builder(
      //   itemBuilder: (context, index) => PocketMoneyPlanWidget(),
      //   itemCount: 1,
      // ),
    );
  }
}
