import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/homepage/child_homepage_controller.dart';
import 'package:zeta_hackathon/widgets/analytics_widget.dart';
import 'package:zeta_hackathon/widgets/balance_widget.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class ChildHomepageScreen extends StatelessWidget {
  ChildHomepageScreen({Key? key}) : super(key: key);
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final childHomepageController =
        Provider.of<ChildHomepageController>(context);
    return CustomScaffold(
      title: 'Hi ${childHomepageController.child?.username ?? 'Name'}',
      showBackButton: false,
      leadingWidget: IconButton(
        onPressed: () => childHomepageController.logout(context),
        icon: Icon(Icons.logout),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await childHomepageController.generateQR(context);
            await childHomepageController.fetchChildDetails();
          },
          icon: Icon(Icons.code),
        )
      ],
      body: Column(
        children: [
          if (childHomepageController.child != null)
            BalanceWidget(child: childHomepageController.child!),
          AnalyticsWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await childHomepageController.scanQR(context);
          await childHomepageController.fetchChildDetails();
        },
        label: Text('Scan QR'),
      ),
    );
  }
}
