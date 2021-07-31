import 'dart:convert';

PocketMoney pocketMoneyFromJson(String str) =>
    PocketMoney.fromJson(json.decode(str));

String pocketMoneyToJson(PocketMoney data) => json.encode(data.toJson());

class PocketMoney {
  PocketMoney({
    required this.amount,
    required this.recurringDays,
    required this.lastAdded,
    required this.childId,
    required this.parentId,
  });

  final double amount;
  final int recurringDays;
  final int lastAdded;
  final String childId;
  final String parentId;

  PocketMoney copyWith({
    double? amount,
    int? recurringDays,
    int? lastAdded,
    String? childId,
    String? parentId,
  }) =>
      PocketMoney(
        amount: amount ?? this.amount,
        recurringDays: recurringDays ?? this.recurringDays,
        lastAdded: lastAdded ?? this.lastAdded,
        childId: childId ?? this.childId,
        parentId: parentId ?? this.parentId,
      );

  factory PocketMoney.fromJson(Map<String, dynamic> json) => PocketMoney(
        amount: json["amount"].toDouble(),
        recurringDays: json["recurring_days"],
        lastAdded: json["last_added"],
        childId: json["child_id"],
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "recurring_days": recurringDays,
        "last_added": lastAdded,
        "child_id": childId,
        "parent_id": parentId,
      };
}
