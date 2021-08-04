import 'package:flutter/material.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class ChildLogin extends StatelessWidget {
  const ChildLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Child Login',
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            CustomButton(onPressed: () {}, text: 'Login'),
          ],
        ),
      ),
    );
  }
}
