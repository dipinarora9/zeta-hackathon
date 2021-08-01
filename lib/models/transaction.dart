import 'dart:convert';

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  Transaction({
    required this.transactionId,
    required this.amount,
    required this.timestamp,
    required this.sender,
    required this.receiver,
    required this.accountHolderId,
  });

  final String transactionId;
  final double amount;
  final int timestamp;
  final String accountHolderId;
  final UserObject sender;
  final UserObject receiver;

  Transaction copyWith({
    String? transactionId,
    double? amount,
    int? timestamp,
    UserObject? sender,
    UserObject? receiver,
    String? accountHolderId,
  }) =>
      Transaction(
        transactionId: transactionId ?? this.transactionId,
        amount: amount ?? this.amount,
        timestamp: timestamp ?? this.timestamp,
        sender: sender ?? this.sender,
        receiver: receiver ?? this.receiver,
        accountHolderId: accountHolderId ?? this.accountHolderId,
      );

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transactionId: json["transaction_id"],
        amount: json["amount"].toDouble(),
        timestamp: json["timestamp"],
        sender: UserObject.fromJson(json["sender"]),
        receiver: UserObject.fromJson(json["receiver"]),
        accountHolderId: json["account_holder_id"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "amount": amount,
        "timestamp": timestamp,
        "account_holder_id": accountHolderId,
        "sender": sender.toJson(),
        "receiver": receiver.toJson(),
      };
}

class UserObject {
  UserObject({
    required this.name,
    required this.id,
  });

  final String name;
  final String id;

  UserObject copyWith({
    String? name,
    String? id,
  }) =>
      UserObject(
        name: name ?? this.name,
        id: id ?? this.id,
      );

  factory UserObject.fromJson(Map<String, dynamic> json) => UserObject(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
