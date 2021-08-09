abstract class CustomUser {
  CustomUser({
    required this.userId,
    required this.createdDate,
    required this.username,
    required this.aadhaarNumber,
    required this.isParent,
    required this.email,
  });

  final String userId;
  final String email;
  final String username;
  final int createdDate;
  final int aadhaarNumber;
  final bool isParent;
}