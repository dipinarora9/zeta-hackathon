import 'dart:convert';

PocketMoney pocketMoneyFromJson(String str) =>
    PocketMoney.fromJson(json.decode(str));

String pocketMoneyToJson(PocketMoney data) => json.encode(data.toJson());

class PocketMoney {
  PocketMoney({
    required this.amount,
    required this.recurringDays,
    required this.parentId,
    required this.planId,
  });

  PocketMoney.empty()
      : this.amount = 0,
        this.recurringDays = 0,
        this.parentId = '',
        this.planId = '';

  final double amount;
  final int recurringDays;
  final String parentId;
  final String planId;

  PocketMoney copyWith({
    double? amount,
    int? recurringDays,
    String? parentId,
    String? planId,
  }) =>
      PocketMoney(
        amount: amount ?? this.amount,
        recurringDays: recurringDays ?? this.recurringDays,
        parentId: parentId ?? this.parentId,
        planId: planId ?? this.planId,
      );

  factory PocketMoney.fromJson(Map<String, dynamic> json) => PocketMoney(
        amount: json["amount"].toDouble(),
        recurringDays: json["recurring_days"],
        parentId: json["parent_id"],
        planId: json["plan_id"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "recurring_days": recurringDays,
        "parent_id": parentId,
        "plan_id": planId,
      };
}
