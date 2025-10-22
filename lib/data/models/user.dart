class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      token: json['token'],
    );
  }
}
