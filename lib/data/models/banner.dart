import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';

class BannerModel {
  BannerModel({
    required this.id,
    this.position,
    required this.media,
    this.mediaType,
    this.sort,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? position;
  final String media;
  final String? mediaType;
  final int? sort;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json["id"],
      position: json["position"],
      media: json["media"]?.toString() ?? AppAssets.temp,
      mediaType: json["media_type"],
      sort: json["sort"],
      status: json["status"],
      createdAt: Utils.parseDate(json["created_at"] ?? ""),
      updatedAt: Utils.parseDate(json["updated_at"] ?? ""),
    );
  }
}
