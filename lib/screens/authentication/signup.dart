import 'package:flutter/material.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

import '../../routes.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Sign Up',
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ),
            CustomButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.homepage),
              text: 'Sign Up',
            ),
          ],
        ),
      ),
    );
  }
}
