import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/homepage/parent_homepage_controller.dart';
import 'package:zeta_hackathon/models/user/child.dart';
import 'package:zeta_hackathon/routes.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';
import 'package:zeta_hackathon/widgets/analytics_widget.dart';
import 'package:zeta_hackathon/widgets/child_widget.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

import '../dependency_injector.dart';

class HomepageScreen extends StatelessWidget {
  HomepageScreen({Key? key}) : super(key: key);
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final IdentityService identityService = sl<IdentityService>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Hi ${identityService.getName()}',
      showBackButton: false,
      leadingWidget: IconButton(
        onPressed: () =>
            context.read<ParentHomepageController>().logout(context),
        icon: Icon(Icons.logout),
      ),
      actions: [
        IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.pocketMoneyPlans),
          icon: Icon(Icons.money),
        )
      ],
      body: SingleChildScrollView(
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: () =>
              context.read<ParentHomepageController>().fetchChildren(),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              childrenWidget(context),
              CustomButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  Routes.modifyChild,
                  arguments: Child.empty(),
                ),
                text: 'Add Child',
              ),
              AnalyticsWidget(),
              CustomButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.debugScreen),
                text: 'Show debug screen',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget childrenWidget(BuildContext context) {
    return Consumer<ParentHomepageController>(builder: (_, value, __) {
      return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: (MediaQuery.of(context).size.height / 9) *
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
