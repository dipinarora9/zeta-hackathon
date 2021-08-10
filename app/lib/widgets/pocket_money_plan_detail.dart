import 'package:flutter/material.dart';
import 'package:zeta_hackathon/models/pocket_money.dart';
import 'package:zeta_hackathon/widgets/custom_button.dart';

class PocketMoneyPlanDetailWidget extends StatefulWidget {
  const PocketMoneyPlanDetailWidget({
    Key? key,
    required this.plan,
  }) : super(key: key);
  final PocketMoney plan;

  @override
  _PocketMoneyPlanDetailWidgetState createState() =>
      _PocketMoneyPlanDetailWidgetState();
}

class _PocketMoneyPlanDetailWidgetState
    extends State<PocketMoneyPlanDetailWidget> {
  late PocketMoney plan;

  @override
  void initState() {
    plan = widget.plan;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Amount'),
            initialValue: plan.amount.toString(),
            keyboardType: TextInputType.number,
            onChanged: (a) => double.tryParse(a) != null
                ? plan = plan.copyWith(amount: double.parse(a))
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Recurring Days'),
            initialValue: plan.recurringDays.toString(),
            keyboardType: TextInputType.number,
            onChanged: (a) => int.tryParse(a) != null
                ? plan = plan.copyWith(recurringDays: int.parse(a))
                : null,
          ),
        ),
        CustomButton(
          onPressed: () => Navigator.of(context).pop(plan),
          text: 'Submit',
        ),
      ],
    );
  }
}
