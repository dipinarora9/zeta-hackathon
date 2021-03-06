import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/homepage/child_homepage_controller.dart';
import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/widgets/analytics_widget.dart';
import 'package:zeta_hackathon/widgets/balance_widget.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

import '../routes.dart';

class ChildHomepageScreen extends StatelessWidget {
  ChildHomepageScreen({Key? key}) : super(key: key);
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final childHomepageController =
        Provider.of<ChildHomepageController>(context);
    return CustomScaffold(
      title: 'Hi ${childHomepageController.child?.username ?? 'Name'}',
      showBackButton: false,
      leadingWidget: IconButton(
        onPressed: () => childHomepageController.logout(context),
        icon: Icon(Icons.logout),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await childHomepageController.generateQR(context);
            await childHomepageController.fetchChildDetails();
          },
          icon: Icon(Icons.code),
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (childHomepageController.child != null)
              BalanceWidget(child: childHomepageController.child!),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomButton(
                onPressed: () => childHomepageController.fetchChildDetails(),
                text: 'Refresh Balance',
              ),
            ),
            // CustomButton(
            //   onPressed: () =>
            //       Navigator.of(context).pushNamed(Routes.debugScreen),
            //   text: 'Show debug screen',
            // ),
            Container(
              child: AnalyticsWidget(),
              height: 245,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (x) => x.toString().length == 10
                    ? null
                    : 'Phone number should be of 10 digits',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onFieldSubmitted: (n) async {
                  UserObject userObject;
                  if (n == '1234567890')
                    userObject = UserObject(
                        name: 'temptest',
                        id: 'uy6SQRj7OVwv8HIki1pB',
                        parentId: 'hjrmGuvkP7NVPaRcssiAqx1JUKk2',
                        accountId: '');
                  else
                    userObject = UserObject(
                        name: 'kenchild',
                        id: '6uKiFUIonSEPayaW8Opn',
                        parentId: 'eZgIQWaeXHhxLztcsGcgIROxXr53',
                        accountId: '');
                  await Navigator.of(context).pushNamed(
                      Routes.transactionScreen,
                      arguments: userObject);
                },
                decoration: InputDecoration(labelText: 'Enter Phone Number'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await childHomepageController.scanQR(context);
          await childHomepageController.fetchChildDetails();
        },
        label: Text('Scan QR'),
      ),
    );
  }
}
