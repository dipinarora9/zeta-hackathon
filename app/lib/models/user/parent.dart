import 'dart:convert';

import 'custom_user.dart';

Parent parentFromJson(String str) => Parent.fromJson(json.decode(str));

String parentToJson(Parent data) => json.encode(data.toJson());

class Parent extends CustomUser {
  Parent({
    required this.accountNumber,
    required this.childrenIds,
    required this.mobile,
    this.latestRenewalDate,
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

  final int accountNumber;
  final int mobile;
  final int? latestRenewalDate;
  final List<String> childrenIds;

  Parent copyWith({
    int? accountNumber,
    List<String>? childrenIds,
    int? mobile,
    String? userId,
    int? createdDate,
    int? aadhaarNumber,
    String? username,
    bool? isParent,
    String? email,
    int? latestRenewalDate,
  }) =>
      Parent(
        accountNumber: accountNumber ?? this.accountNumber,
        childrenIds: childrenIds ?? this.childrenIds,
        mobile: mobile ?? this.mobile,
        userId: userId ?? this.userId,
        createdDate: createdDate ?? this.createdDate,
        aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
        isParent: isParent ?? this.isParent,
        username: username ?? this.username,
        email: email ?? this.email,
        latestRenewalDate: latestRenewalDate ?? this.latestRenewalDate,
      );

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
        accountNumber:
            json["account_number"] == null ? null : json["account_number"],
        childrenIds: json["children_ids"] == null
            ? List<String>.empty()
            : List<String>.from(json["children_ids"].map((x) => x)),
        mobile: json["mobile"] == null ? null : json["mobile"],
        userId: json["user_id"] == null ? null : json["user_id"],
        createdDate: json["created_date"] == null ? null : json["created_date"],
        aadhaarNumber:
            json["aadhaar_number"] == null ? null : json["aadhaar_number"],
        isParent: json["is_parent"] == null ? null : json["is_parent"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        latestRenewalDate: json["latest_renewal_date"] == null
            ? null
            : json["latest_renewal_date"],
      );

  Map<String, dynamic> toJson() => {
        "account_number": accountNumber,
        "children_ids": List<dynamic>.from(childrenIds.map((x) => x)),
        "mobile": mobile,
        "user_id": userId,
        "created_date": createdDate,
        "aadhaar_number": aadhaarNumber,
        "is_parent": isParent,
        "username": username,
        "email": email,
        "latest_renewal_date": latestRenewalDate,
      };
}
