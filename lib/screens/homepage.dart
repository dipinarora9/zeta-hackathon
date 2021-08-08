import 'package:flutter/material.dart';
import 'package:zeta_hackathon/routes.dart';
import 'package:zeta_hackathon/widgets/analytics_widget.dart';
import 'package:zeta_hackathon/widgets/child_widget.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Hi Name',
      actions: [
        IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.pocketMoneyPlans),
          icon: Icon(Icons.money),
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnalyticsWidget(),
            childrenWidget(context),
          ],
        ),
      ),
    );
  }

  Widget childrenWidget(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: ListView.builder(
        itemBuilder: (context, index) => ChildWidget(),
        itemCount: 1,
      ),
    );
  }
}
