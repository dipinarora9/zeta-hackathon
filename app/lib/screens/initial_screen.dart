import 'package:flutter/material.dart';
import 'package:zeta_hackathon/services/dynamic_links_service.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

import '../routes.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '',
      showBackButton: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(Routes.loginParent),
            text: 'Parent',
          ),
          CustomButton(
            onPressed: () => Navigator.of(context).pushNamed(Routes.signUp),
            text: 'New user? Sign Up',
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (s) async {
                Uri data = Uri.parse(s);

                DynamicLinks.parseDynamicLinkData2(context, data);
              },
            ),
          ),
        ],
      ),
    );
  }
}
