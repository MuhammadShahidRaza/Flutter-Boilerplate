import 'package:sanam_laundry/core/index.dart';

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
      title: json['title'] ?? "",
      amount: json['amount'] ?? "",
      subtitle: json['description'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? AppAssets.user,
      currency: json['currency'] ?? "SAR",
    );
  }
}
