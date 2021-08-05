import 'package:flutter/material.dart';
import 'package:zeta_hackathon/widgets/analytics_widget.dart';
import 'package:zeta_hackathon/widgets/balance_widget.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class ChildHomepageScreen extends StatelessWidget {
  const ChildHomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Homepage',
      body: Column(
        children: [
          BalanceWidget(),
          AnalyticsWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Scan QR'),
      ),
    );
  }
}
