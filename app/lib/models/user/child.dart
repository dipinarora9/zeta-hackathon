import 'dart:convert';

import 'package:zeta_hackathon/models/transaction.dart';
import 'package:zeta_hackathon/models/user/custom_user.dart';

Child childFromJson(String str) => Child.fromJson(json.decode(str));

String childToJson(Child data) => json.encode(data.toJson());

class Child extends CustomUser {
  Child({
    this.pocketMoneyDetails,
    required this.balance,
    required this.paymentPermissionRequired,
    required this.parentId,
    required userId,
    required createdDate,
    required aadhaarNumber,
    required isParent,
    required username,
    required email,
    required dob,
  }) : super(
          userId: userId,
          createdDate: createdDate,
          aadhaarNumber: aadhaarNumber,
          isParent: isParent,
          username: username,
          email: email,
          dob: dob,
        );

  Child.empty()
      : balance = 0,
        paymentPermissionRequired = false,
        parentId = '',
        pocketMoneyDetails = null,
        super(
          userId: '',
          createdDate: 0,
          aadhaarNumber: 0,
          isParent: false,
          username: '',
          email: '',
          dob: DateTime(1970, 4, 1),
        );
  final String parentId;
  final bool paymentPermissionRequired;
  final PocketMoneyDetails? pocketMoneyDetails;
  final double balance;

  Child copyWith({
    String? parentId,
    bool? paymentPermissionRequired,
    PocketMoneyDetails? pocketMoneyDetails,
    double? balance,
    String? userId,
    int? createdDate,
    int? aadhaarNumber,
    String? username,
    bool? isParent,
    String? email,
    DateTime? dob,
  }) =>
      Child(
        parentId: parentId ?? this.parentId,
        pocketMoneyDetails: pocketMoneyDetails ?? this.pocketMoneyDetails,
        paymentPermissionRequired:
            paymentPermissionRequired ?? this.paymentPermissionRequired,
        balance: balance ?? this.balance,
        userId: userId ?? this.userId,
        createdDate: createdDate ?? this.createdDate,
        aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
        isParent: isParent ?? this.isParent,
        username: username ?? this.username,
        email: email ?? this.email,
        dob: dob ?? this.dob,
      );

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        paymentPermissionRequired: json["payment_permission_required"] == null
            ? null
            : json["payment_permission_required"],
        pocketMoneyDetails: json["pocket_money_details"] == null
            ? null
            : PocketMoneyDetails.fromJson(json["pocket_money_details"]),
        balance: json["balance"] == null ? null : json["balance"].toDouble(),
        userId: json["user_id"] == null ? null : json["user_id"],
        createdDate: json["created_date"] == null ? null : json["created_date"],
        aadhaarNumber:
            json["aadhaar_number"] == null ? null : json["aadhaar_number"],
        isParent: json["is_parent"] == null ? null : json["is_parent"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
      );

  Map<String, dynamic> toJson() => {
        "parent_id": parentId,
        "payment_permission_required": paymentPermissionRequired,
        "pocket_money_details":
            pocketMoneyDetails == null ? null : pocketMoneyDetails!.toJson(),
        "balance": balance,
        "user_id": userId,
        "created_date": createdDate,
        "aadhaar_number": aadhaarNumber,
        "is_parent": isParent,
        "username": username,
        "email": email,
        "dob": dob.toIso8601String(),
      };

  Map<String, dynamic> toFusionAPIJson() => {
        "firstName": username,
        "dob": {"year": dob.year, "month": dob.month, "day": dob.day},
        "kycDetails": {
          "kycStatus": "MINIMAL",
          "kycStatusPostExpiry": "string",
          "kycAttributes": {},
          "authData": {"AADHAR": aadhaarNumber},
          "authType": "AADHAR"
        },
        "vectors": [
          {"type": "e", "value": email, "isVerified": false}
        ],
      };

  bool isEmpty() => userId == '';

  UserObject toUserObject() => UserObject(
        name: username,
        id: userId,
        parentId: parentId,
        email: email,
      );
}

PocketMoneyDetails pocketMoneyDetailsFromJson(String str) =>
    PocketMoneyDetails.fromJson(json.decode(str));

String pocketMoneyDetailsToJson(PocketMoneyDetails data) =>
    json.encode(data.toJson());

class PocketMoneyDetails {
  PocketMoneyDetails({
    required this.renewalDate,
    required this.pocketMoneyPlanId,
  });

  final int renewalDate;
  final String pocketMoneyPlanId;

  PocketMoneyDetails copyWith({
    int? renewalDate,
    String? pocketMoneyPlanId,
  }) =>
      PocketMoneyDetails(
        renewalDate: renewalDate ?? this.renewalDate,
        pocketMoneyPlanId: pocketMoneyPlanId ?? this.pocketMoneyPlanId,
      );

  factory PocketMoneyDetails.fromJson(Map<String, dynamic> json) =>
      PocketMoneyDetails(
        renewalDate: json["renewal_date"],
        pocketMoneyPlanId: json["pocket_money_plan_id"],
      );

  Map<String, dynamic> toJson() => {
        "renewal_date": renewalDate,
        "pocket_money_plan_id": pocketMoneyPlanId,
      };
}
