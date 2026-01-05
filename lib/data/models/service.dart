import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';

class ServiceItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String amount;
  final String image;
  final String description;
  final String currency;

  ServiceItemModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.image,
    required this.currency,
    required this.description,
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: json['id'].toString(),
      title: Utils.capitalize(json['title'] ?? ""),
      amount: json['amount'] ?? "",
      subtitle: Utils.capitalize(json['description'] ?? ""),
      description: Utils.capitalize(json['description'] ?? ""),
      image: json['image'] ?? AppAssets.user,
      currency: "SAR",
    );
  }
}
