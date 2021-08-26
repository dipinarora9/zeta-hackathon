import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/signup_controller.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupController =
        Provider.of<SignUpController>(context, listen: false);
    return CustomScaffold(
      title: 'Sign Up',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: signupController.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: signupController.passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: signupController.panController,
                decoration: InputDecoration(labelText: 'PAN'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: signupController.usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (s) {
                  List<String> d = s.split('-');
                  if (d.length == 3) {
                    int? year = int.tryParse(d.last);
                    int? month = int.tryParse(d[1]);
                    int? date = int.tryParse(d.first);
                    if (year != null && month != null && date != null)
                      signupController.setDate(DateTime(year, month, date));
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Date of Birth', hintText: '01-01-2000'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: signupController.mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
              ),
            ),
            CustomButton(
              onPressed: () async {
                await context.read<SignUpController>().signUp();
                Navigator.of(context).pop();
              },
              text: 'Sign Up',
            ),
          ],
        ),
      ),
    );
  }
}
