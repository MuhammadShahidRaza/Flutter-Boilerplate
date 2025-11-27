import 'package:sanam_laundry/core/utils/helper.dart';

class AddressModel {
  AddressModel({
    required this.id,
    this.userId,
    this.label,
    required this.address,
    this.city,
    this.state,
    this.latitude,
    this.buildingName,
    this.floor,
    this.longitude,
    this.buildingImage,
    this.apartmentImage,
    this.isActive,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
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
      isActive: int.tryParse(json["is_active"]?.toString() ?? "0"),
      isDefault: int.tryParse(json["is_default"]?.toString() ?? "0"),
      createdAt: Utils.parseDate(json["created_at"]),
      updatedAt: Utils.parseDate(json["updated_at"]),
    );
  }
}
