import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/homepage/child_homepage_controller.dart';
import 'package:zeta_hackathon/routes.dart';
import 'package:zeta_hackathon/widgets/analytics_widget.dart';
import 'package:zeta_hackathon/widgets/balance_widget.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class ChildHomepageScreen extends StatelessWidget {
  const ChildHomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Hi Name',
      showBackButton: false,
      leadingWidget: IconButton(
        onPressed: () =>
            context.read<ChildHomepageController>().logout(context),
        icon: Icon(Icons.logout),
      ),
      body: Column(
        children: [
          BalanceWidget(),
          AnalyticsWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.of(context).pushNamed(Routes.transactionScreen),
        label: Text('Scan QR'),
      ),
    );
  }
}
