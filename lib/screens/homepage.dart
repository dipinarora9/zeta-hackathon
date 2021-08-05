import 'package:flutter/material.dart';
import 'package:zeta_hackathon/widgets/analytics_widget.dart';
import 'package:zeta_hackathon/widgets/child_widget.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Homepage',
      body: Column(
        children: [
          AnalyticsWidget(),
          childrenWidget(),
        ],
      ),
    );
  }

  Widget childrenWidget() {
    return ListView.builder(
      itemBuilder: (context, index) => ChildWidget(),
    );
  }
}
