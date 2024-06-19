// lib/models/user.dart
class User {
  final String username;
  final String password;
  final String? token;

  User({required this.username, required this.password, this.token});
}
