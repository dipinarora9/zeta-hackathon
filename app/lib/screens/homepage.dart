import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/homepage/parent_homepage_controller.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/routes.dart';
import 'package:zeta_hackathon/widgets/analytics_widget.dart';
import 'package:zeta_hackathon/widgets/child_widget.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
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
            CustomButton(
                onPressed: () => Navigator.of(context).pushNamed(
                      Routes.modifyChild,
                      arguments: Child.empty(),
                    ),
                text: 'Add Child'),
          ],
        ),
      ),
    );
  }

  Widget childrenWidget(BuildContext context) {
    return Consumer<ParentHomepageController>(builder: (_, value, __) {
      return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: (MediaQuery.of(context).size.height / 8) *
                value.children.length),
        child: ListView.builder(
          itemBuilder: (context, index) =>
              ChildWidget(child: value.children.values.toList()[index]),
          itemCount: value.children.length,
        ),
      );
    });
  }
}
