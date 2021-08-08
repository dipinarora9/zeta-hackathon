import 'package:flutter/material.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

import '../routes.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

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
            onPressed: () => Navigator.of(context).pushNamed(Routes.loginChild),
            text: 'Child',
          ),
          CustomButton(
            onPressed: () => Navigator.of(context).pushNamed(Routes.signUp),
            text: 'New user? Sign Up',
          ),
        ],
      ),
    );
  }
}
