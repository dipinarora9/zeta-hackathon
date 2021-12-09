import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/login_controller.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

import '../../routes.dart';

class ChildLogin extends StatelessWidget {
  const ChildLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginController>(context);
    return CustomScaffold(
      title: 'Child Login',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: loginController.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: loginController.passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ),
            DropdownButton<String>(
              items: loginController.parentIds.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(loginController.parentIds[key]!),
                );
              }).toList(),
              value: loginController.parentId,
              onChanged: (p) => loginController.setParentId(p!),
            ),
            CustomButton(
              onPressed: () async {
                bool loggedIn =
                    await context.read<LoginController>().loginAsChild();
                if (loggedIn)
                  Navigator.of(context).pushNamed(Routes.homepageChild);
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
