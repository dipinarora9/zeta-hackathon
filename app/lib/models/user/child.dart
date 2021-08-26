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
    required this.poolAccountID,
    required userId,
    required createdDate,
    required pan,
    required isParent,
    required username,
    required email,
    required dob,
  }) : super(
          userId: userId,
          createdDate: createdDate,
          pan: pan,
          isParent: isParent,
          username: username,
          email: email,
          dob: dob,
        );

  Child.empty()
      : balance = 0,
        paymentPermissionRequired = false,
        parentId = '',
        poolAccountID = '',
        pocketMoneyDetails = null,
        super(
          userId: '',
          createdDate: 0,
          pan: '',
          isParent: false,
          username: '',
          email: '',
          dob: DateTime(1970, 4, 1),
        );
  final String parentId;
  final bool paymentPermissionRequired;
  final PocketMoneyDetails? pocketMoneyDetails;
  final double balance;
  final String poolAccountID;

  Child copyWith({
    String? parentId,
    bool? paymentPermissionRequired,
    PocketMoneyDetails? pocketMoneyDetails,
    double? balance,
    String? userId,
    int? createdDate,
    String? pan,
    String? username,
    bool? isParent,
    String? email,
    DateTime? dob,
    String? poolAccountID,
  }) =>
      Child(
        parentId: parentId ?? this.parentId,
        pocketMoneyDetails: pocketMoneyDetails ?? this.pocketMoneyDetails,
        paymentPermissionRequired:
            paymentPermissionRequired ?? this.paymentPermissionRequired,
        balance: balance ?? this.balance,
        userId: userId ?? this.userId,
        createdDate: createdDate ?? this.createdDate,
        pan: pan ?? this.pan,
        isParent: isParent ?? this.isParent,
        username: username ?? this.username,
        email: email ?? this.email,
        dob: dob ?? this.dob,
        poolAccountID: poolAccountID ?? this.poolAccountID,
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
        pan: json["pan"] == null ? null : json["pan"],
        isParent: json["is_parent"] == null ? null : json["is_parent"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        poolAccountID:
            json["pool_account_id"] == null ? null : json["pool_account_id"],
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
        "pan": pan,
        "is_parent": isParent,
        "username": username,
        "email": email,
        "pool_account_id": poolAccountID,
        "dob": dob.toIso8601String(),
      };

  Map<String, dynamic> toFusionAPIJson(String targetAccountID) => {
        "firstName": username,
        "dob": {"year": dob.year, "month": dob.month, "day": dob.day},
        "kycDetails": {
          "kycStatus": "MINIMAL",
          "kycStatusPostExpiry": "string",
          "kycAttributes": {},
          "authData": {"PAN": pan},
          "authType": "PAN"
        },
        "vectors": [
          {"type": "e", "value": email, "isVerified": false}
        ],
        'targetAccountID': targetAccountID
      };

  bool isEmpty() => userId == '';

  UserObject toUserObject() => UserObject(
        name: username,
        id: userId,
        parentId: parentId,
        accountId: poolAccountID,
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
