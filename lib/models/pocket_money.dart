import 'dart:convert';

PocketMoney pocketMoneyFromJson(String str) =>
    PocketMoney.fromJson(json.decode(str));

String pocketMoneyToJson(PocketMoney data) => json.encode(data.toJson());

class PocketMoney {
  PocketMoney({
    required this.amount,
    required this.recurringDays,
    required this.parentId,
  });

  final double amount;
  final int recurringDays;
  final String parentId;

  PocketMoney copyWith({
    double? amount,
    int? recurringDays,
    String? parentId,
  }) =>
      PocketMoney(
        amount: amount ?? this.amount,
        recurringDays: recurringDays ?? this.recurringDays,
        parentId: parentId ?? this.parentId,
      );

  factory PocketMoney.fromJson(Map<String, dynamic> json) => PocketMoney(
        amount: json["amount"].toDouble(),
        recurringDays: json["recurring_days"],
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "recurring_days": recurringDays,
        "parent_id": parentId,
      };
}
