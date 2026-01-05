import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/index.dart';

class NotificationModel {
  NotificationModel({
    required this.id,
    this.userId,
    required this.title,
    required this.body,
    this.objectableType,
    this.objectableId,
    this.actorId,
    required this.type,
    this.viewed,
    this.status,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.actor,
  });

  final int? id;
  final int? userId;
  final String? title;
  final String? body;
  final String? objectableType;
  final int? objectableId;
  final int? actorId;
  final String? type;
  final int? viewed;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final UserModel? user;
  final UserModel? actor;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"],
      userId: json["user_id"],
      title: json["title"],
      body: json["body"],
      objectableType: json["objectable_type"],
      objectableId: json["objectable_id"],
      actorId: json["actor_id"],
      type: json["type"],
      viewed: json["viewed"],
      status: json["status"],
      createdAt: Utils.parseDate(json["created_at"]) ?? DateTime.now(),
      updatedAt: Utils.parseDate(json["updated_at"]) ?? DateTime.now(),
      deletedAt: Utils.parseDate(json["created_at"]) ?? DateTime.now(),
      user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      actor: json["actor"] == null ? null : UserModel.fromJson(json["actor"]),
    );
  }
}
