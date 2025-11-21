class AddressModel {
  AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? userId;
  final String? label;
  final String? address;
  final String? city;
  final String? state;
  final String? latitude;
  final String? longitude;
  final int? isActive;
  final int? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json["id"],
      userId: json["user_id"],
      label: json["label"],
      address: json["address"],
      city: json["city"],
      state: json["state"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      isActive: json["is_active"],
      isDefault: json["is_default"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}
