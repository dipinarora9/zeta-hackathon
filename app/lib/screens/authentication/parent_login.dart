import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/login_controller.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

import '../../routes.dart';

class ParentLogin extends StatelessWidget {
  const ParentLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Parent Login',
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
              onPressed: () async {
                await context.read<LoginController>().loginAsParent();
                Navigator.of(context).pushNamed(Routes.homepage);
              },
              text: 'Login',
            ),
            CustomButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(Routes.signUp),
              text: 'Sign Up',
            ),
          ],
        ),
      ),
    );
  }
}
