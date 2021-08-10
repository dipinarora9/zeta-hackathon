import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/children_controller.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class ModifyChildScreen extends StatelessWidget {
  const ModifyChildScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childrenController =
        Provider.of<ChildrenController>(context, listen: false);
    return CustomScaffold(
      title: childrenController.child.isEmpty() ? 'Add Child' : 'Edit Child',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: childrenController.emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: childrenController.aadhaarController,
                decoration: InputDecoration(labelText: 'Aadhar Number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: childrenController.usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ),
            CustomButton(
              onPressed: () =>
                  context.read<ChildrenController>().saveChild(context),
              text: 'Add Child',
            ),
            if (!childrenController.child.isEmpty())
              CustomButton(
                onPressed: () async {
                  await context.read<ChildrenController>().deleteChild(context);
                },
                text: 'Delete Child',
              ),
          ],
        ),
      ),
    );
  }
}
