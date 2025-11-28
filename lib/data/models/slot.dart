import 'package:intl/intl.dart';
import 'package:sanam_laundry/core/utils/helper.dart';

class SlotModel {
  SlotModel({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String? title;
  final String? startTime;
  final String? endTime;
  final int? isActive;
  final dynamic createdAt;
  final dynamic updatedAt;

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    String? formatLocal(String? iso) {
      if (iso == null) return null;
      final dt = DateTime.tryParse(iso);
      if (dt == null) return null;
      return DateFormat('h:mm a').format(dt.toLocal());
    }

    return SlotModel(
      id: json["id"]?.toString() ?? "",
      title: Utils.capitalize(json["title"]),
      startTime: formatLocal(json["start_time"]),
      endTime: formatLocal(json["end_time"]),
      isActive: json["is_active"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}
