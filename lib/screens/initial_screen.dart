import 'package:flutter/material.dart';
import 'package:zeta_hackathon/screens/authentication/child_login.dart';
import 'package:zeta_hackathon/screens/authentication/parent_login.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '',
      showBackButton: false,
      body: Center(
        child: Column(
          children: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ParentLogin(),
                  ),
                );
              },
              text: 'Parent',
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChildLogin(),
                  ),
                );
              },
              text: 'Child',
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ParentLogin(),
                  ),
                );
              },
              text: 'New user? Sign Up',
            ),
          ],
        ),
      ),
    );
  }
}
