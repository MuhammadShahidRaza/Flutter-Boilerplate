class SettingsModel {
  SettingsModel({
    required this.normalDelivery,
    required this.expressDelivery,
    required this.freeDeliveryThreshold,
    required this.normalDeliveryDays,
    required this.expressDeliveryDays,
    required this.taxPercentage,
    this.currency,
  });

  final num normalDelivery;
  final num expressDelivery;
  final num freeDeliveryThreshold;
  final num normalDeliveryDays;
  final num expressDeliveryDays;
  final num taxPercentage;
  final String? currency;

  static num _toNum(dynamic v, num fb) {
    if (v == null) return fb;
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? fb;
    return fb;
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      normalDelivery: _toNum(json["normal_delivery"], 2),
      expressDelivery: _toNum(json["express_delivery"], 1),
      freeDeliveryThreshold: _toNum(json["free_delivery_threshold"], 0),
      normalDeliveryDays: _toNum(json["normal_delivery_days"], 2),
      expressDeliveryDays: _toNum(json["express_delivery_days"], 1),
      taxPercentage: _toNum(json["tax_percentage"], 5),
      currency: "SAR",
    );
  }
}
