import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';

class CategoryModel {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.title,
    this.subtitle = "",
    this.image = AppAssets.user,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      subtitle: (json['description'] ?? "").toString(),
      image: json['image']?.toString() ?? AppAssets.user,
      createdAt: Utils.parseDate(json['created_at']),
      updatedAt: Utils.parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': subtitle,
    'image': image,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
