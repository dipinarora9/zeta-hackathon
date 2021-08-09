import 'dart:convert';

NotificationRequest notificationRequestFromJson(String str) =>
    NotificationRequest.fromJson(json.decode(str));

String notificationRequestToJson(NotificationRequest data) =>
    json.encode(data.toJson());

class NotificationRequest {
  NotificationRequest({
    required this.amount,
    required this.reason,
    required this.childId,
    required this.parentId,
    required this.budgetExceeded,
  });

  final double amount;
  final String reason;
  final String childId;
  final String parentId;
  final bool budgetExceeded;

  NotificationRequest copyWith({
    double? amount,
    String? reason,
    String? childId,
    String? parentId,
    bool? budgetExceeded,
  }) =>
      NotificationRequest(
        amount: amount ?? this.amount,
        reason: reason ?? this.reason,
        childId: childId ?? this.childId,
        parentId: parentId ?? this.parentId,
        budgetExceeded: budgetExceeded ?? this.budgetExceeded,
      );

  factory NotificationRequest.fromJson(Map<String, dynamic> json) =>
      NotificationRequest(
        amount: json["amount"].toDouble(),
        reason: json["reason"],
        childId: json["child_id"],
        parentId: json["parent_id"],
        budgetExceeded: json["budget_exceeded"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "reason": reason,
        "child_id": childId,
        "parent_id": parentId,
        "budget_exceeded": budgetExceeded,
      };
}
