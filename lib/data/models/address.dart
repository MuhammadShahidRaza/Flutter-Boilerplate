import 'package:sanam_laundry/core/utils/helper.dart';

class AddressModel {
  AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.buildingName,
    required this.floor,
    required this.longitude,
    required this.buildingImage,
    required this.apartmentImage,
    required this.isActive,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int? userId;
  final String? label;
  final String? address;
  final String? city;
  final String? state;
  final String? latitude;
  final String? longitude;
  final String? floor;
  final String? buildingName;
  final int? isActive;
  final int? isDefault;
  final String? buildingImage;
  final String? apartmentImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AddressModel.fromJson(Map<dynamic, dynamic> json) {
    return AddressModel(
      id: json["id"],
      userId: json["user_id"],
      label: json["label"] ?? "",
      address: json["address"] ?? "",
      buildingName: json["building_name"] ?? "",
      buildingImage: json["building_image_url"] ?? "",
      apartmentImage: json["apartment_image_url"] ?? "",
      floor: json["floor"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      latitude: json["latitude"] ?? "",
      longitude: json["longitude"] ?? "",
      isActive: json["is_active"],
      isDefault: json["is_default"],
      createdAt: Utils.parseDate(json["created_at"]),
      updatedAt: Utils.parseDate(json["updated_at"]),
    );
  }
}
