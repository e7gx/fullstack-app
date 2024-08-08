class User {
  final String username;
  final String accessToken;
  final String refreshToken;

  User({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  });

  // Adjust the `fromJson` factory constructor to handle the nested token structure
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      accessToken: json['token']['access'] as String,
      refreshToken: json['token']['refresh'] as String,
    );
  }
}
