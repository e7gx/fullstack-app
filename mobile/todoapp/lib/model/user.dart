class User {
  final String username;
  final String address;
  final String token;

  User({
    required this.username,
    required this.address,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '', // Default to empty string if null
      address: json['address'] ?? '', // Default to empty string if null
      token: json['token'] ?? '', // Default to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'address': address,
      'token': token,
    };
  }
}
