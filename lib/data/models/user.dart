import 'package:sanam_laundry/providers/index.dart';

class UserModel {
  final int id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String phone;
  final String? providerId;
  final String? provider;
  final String? countryCode;
  final String? bio;
  final String userType;
  final String? userRole;
  final String? customerId;
  final String? profileImage;
  final String? gender;
  final int? isRiderActive;
  final int? status;
  final String? language;
  final String? createdAt;
  final String? token;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.providerId,
    this.provider,
    this.countryCode,
    this.bio,
    required this.userType,
    this.userRole,
    this.customerId,
    this.profileImage,
    this.gender,
    this.isRiderActive,
    this.status,
    this.language,
    this.createdAt,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      providerId: json['provider_id']?.toString(),
      provider: json['provider'],
      countryCode: json['country_code'],
      bio: json['bio'],
      userType: json['user_type'] ?? "",
      userRole: json['user_role'],

      customerId: json['customer_id'] ?? "",
      profileImage: json['profile_image'],
      gender: json['gender'],
      isRiderActive: json['is_rider_active'],
      status: json['status'],
      language: json['language'] ?? Language.en.name,
      createdAt: json['created_at'],
      token: json['token'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'provider_id': providerId,
      'provider': provider,
      'country_code': countryCode,
      'bio': bio,
      'user_type': userType,
      'user_role': userRole,
      'customer_id': customerId,
      'profile_image': profileImage,
      'gender': gender,
      'is_rider_active': isRiderActive,
      'status': status,
      'language': language,
      'created_at': createdAt,
      'token': token,
    };
  }
}
