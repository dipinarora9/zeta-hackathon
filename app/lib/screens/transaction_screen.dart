import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeta_hackathon/controllers/transaction_controller.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionController =
        Provider.of<TransactionController>(context, listen: false);
    return CustomScaffold(
      title: 'Send Money to ${transactionController.receiver.name}',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: EditableText(
                  controller: transactionController.amountController,
                  focusNode: FocusNode(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 55,
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  cursorColor: Colors.blueAccent,
                  backgroundCursorColor: Colors.blue,
                ),
              ),
            ],
          ),
          CustomButton(
            onPressed: () => transactionController.sendMoney(context),
            text: 'Pay',
          ),
        ],
      ),
    );
  }
}
