import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/children_controller.dart';
import 'package:zeta_hackathon/models/pocket_money.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class ModifyChildScreen extends StatelessWidget {
  const ModifyChildScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childrenController = Provider.of<ChildrenController>(context);
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
                controller: childrenController.panController,
                decoration: InputDecoration(labelText: 'PAN'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: childrenController.usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Choose Pocket Money Plan'),
            ),
            DropdownButton<String>(
              value: childrenController.currentSelectedPlan,
              hint: Text('Select Plan'),
              onChanged: (s) => childrenController.setPlan(s),
              items: childrenController.plans.values
                  .toList()
                  .map<DropdownMenuItem<String>>((PocketMoney plan) {
                return DropdownMenuItem<String>(
                  value: plan.planId,
                  child: Text(
                      'Amount - ${plan.amount} Recurring Days - ${plan.recurringDays}'),
                );
              }).toList(),
            ),
            SwitchListTile(
              title: Text('Payment permission required?'),
              value: childrenController.permissionRequired,
              onChanged: childrenController.setPermission,
            ),
            CustomButton(
              onPressed: () =>
                  context.read<ChildrenController>().saveChild(context),
              text: !childrenController.child.isEmpty()
                  ? 'Save Child'
                  : 'Add Child',
            ),
            if (!childrenController.child.isEmpty())
              CustomButton(
                onPressed: () async {
                  await context.read<ChildrenController>().resendInvite();
                },
                text: 'Resend Invite',
              ),
            if (!childrenController.child.isEmpty())
              CustomButton(
                onPressed: () async {
                  await context.read<ChildrenController>().deleteChild(context);
                },
                bgColor: Colors.red.withOpacity(0.8),
                text: 'Delete Child',
              ),
          ],
        ),
      ),
    );
  }
}
