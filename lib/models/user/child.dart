import 'dart:convert';

import 'package:zeta_hackathon/models/user/custom_user.dart';

Child childFromJson(String str) => Child.fromJson(json.decode(str));

String childToJson(Child data) => json.encode(data.toJson());

class Child extends CustomUser {
  Child({
    required this.transactionLimit,
    required this.balance,
    required this.paymentPermissionRequired,
    required this.parentId,
    required userId,
    required createdDate,
    required aadhaarNumber,
    required isParent,
    required username,
    required email,
  }) : super(
          userId: userId,
          createdDate: createdDate,
          aadhaarNumber: aadhaarNumber,
          isParent: isParent,
          username: username,
          email: email,
        );

  final String parentId;
  final bool paymentPermissionRequired;
  final double transactionLimit;
  final double balance;

  Child copyWith({
    String? parentId,
    bool? paymentPermissionRequired,
    double? transactionLimit,
    double? balance,
    String? userId,
    int? createdDate,
    int? aadhaarNumber,
    String? username,
    bool? isParent,
    String? email,
  }) =>
      Child(
        parentId: parentId ?? this.parentId,
        paymentPermissionRequired:
            paymentPermissionRequired ?? this.paymentPermissionRequired,
        transactionLimit: transactionLimit ?? this.transactionLimit,
        balance: balance ?? this.balance,
        userId: userId ?? this.userId,
        createdDate: createdDate ?? this.createdDate,
        aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
        isParent: isParent ?? this.isParent,
        username: username ?? this.username,
        email: email ?? this.email,
      );

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        paymentPermissionRequired: json["payment_permission_required"] == null
            ? null
            : json["payment_permission_required"],
        transactionLimit: json["transaction_limit"] == null
            ? null
            : json["transaction_limit"].toDouble(),
        balance: json["balance"] == null ? null : json["balance"].toDouble(),
        userId: json["user_id"] == null ? null : json["user_id"],
        createdDate: json["created_date"] == null ? null : json["created_date"],
        aadhaarNumber:
            json["aadhaar_number"] == null ? null : json["aadhaar_number"],
        isParent: json["is_parent"] == null ? null : json["is_parent"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "parent_id": parentId,
        "payment_permission_required": paymentPermissionRequired,
        "transaction_limit": transactionLimit,
        "balance": balance,
        "user_id": userId,
        "created_date": createdDate,
        "aadhaar_number": aadhaarNumber,
        "is_parent": isParent,
        "username": username,
        "email": email,
      };
}
