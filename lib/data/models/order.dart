import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/models/slot.dart';

class OrderModel {
  OrderModel({
    required this.id,
    required this.userId,
    required this.riderId,
    required this.zoneId,
    required this.deliveryType,
    required this.pickupDatetime,
    required this.pickupSlotId,
    required this.deliveryDatetime,
    required this.deliverySlotId,
    required this.address,
    required this.orderNumber,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.appartmentImage,
    required this.buildingImage,
    required this.status,
    required this.nextStatus,
    required this.paymentStatus,
    required this.subTotal,
    required this.tax,
    required this.deliveryCharges,
    required this.totalAmount,
    required this.paymentMethod,
    required this.transactionId,
    required this.transactionReference,
    required this.specialInstructions,
    required this.createdAt,
    required this.updatedAt,
    required this.ironingId,
    required this.starchId,
    required this.clothesReturnedId,
    required this.statusList,
    // required this.ironingLevel,
    // required this.starchLevel,
    // required this.clothesReturned,
    required this.user,
    required this.rider,
    required this.bookingDetail,
    required this.pickupSlot,
    required this.deliverySlot,
  });

  final int? id;
  final int? userId;
  final dynamic riderId;
  final int? zoneId;
  final String? deliveryType;
  final DateTime? pickupDatetime;
  final String? pickupSlotId;
  final DateTime? deliveryDatetime;
  final String? deliverySlotId;
  final String? address;
  final String? city;
  final String? state;
  final String? latitude;
  final String? longitude;
  final String status;
  final String nextStatus;
  final String? paymentStatus;
  final String? subTotal;
  final String? tax;
  final String? deliveryCharges;
  final String? orderNumber;
  final String? buildingImage;
  final String? appartmentImage;
  final String? totalAmount;
  final dynamic paymentMethod;
  final dynamic transactionId;
  final dynamic transactionReference;
  final String specialInstructions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic ironingId;
  final dynamic statusList;
  final dynamic starchId;
  final dynamic clothesReturnedId;
  // final dynamic ironingLevel;
  // final dynamic starchLevel;
  // final dynamic clothesReturned;
  final UserModel? user;
  final dynamic rider;
  final List<BookingDetail> bookingDetail;
  final SlotModel? pickupSlot;
  final SlotModel? deliverySlot;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      userId: json["user_id"],
      riderId: json["rider_id"],
      zoneId: json["zone_id"],
      deliveryType: json["delivery_type"],
      pickupDatetime: DateTime.tryParse(json["pickup_datetime"] ?? ""),
      pickupSlotId: json["pickup_slot_id"]?.toString() ?? "",
      deliveryDatetime: DateTime.tryParse(json["delivery_datetime"] ?? ""),
      deliverySlotId: json["delivery_slot_id"]?.toString() ?? "",
      address: json["address"],
      city: json["city"],
      state: json["state"],
      orderNumber: json["order_number"],
      latitude: json["latitude"],
      buildingImage: json["building_image_url"],
      appartmentImage: json["apartment_image_url"],
      longitude: json["longitude"],
      status: json["status"] ?? "",
      nextStatus: json["next_status"] ?? "",
      paymentStatus: json["payment_status"],
      subTotal: json["sub_total"] == null ? "0" : json["sub_total"].toString(),
      tax: json["tax"] == null ? "0" : json["tax"].toString(),
      deliveryCharges: json["delivery_charges"] == null
          ? "0"
          : json["delivery_charges"].toString(),
      totalAmount: json["total_amount"] == null
          ? "0"
          : json["total_amount"].toString(),
      paymentMethod: json["payment_method"],
      transactionId: json["transaction_id"],
      transactionReference: json["transaction_reference"],
      specialInstructions: json["special_instructions"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      ironingId: json["ironing_id"],
      starchId: json["starch_id"],
      clothesReturnedId: json["clothes_returned_id"],
      statusList: json["status_list"] != null
          ? json["status_list"]
                .replaceAll("[", "")
                .replaceAll("]", "")
                .replaceAll("'", "")
                .split(",")
                .map((e) => e.trim())
                .toList()
          : [],

      // ironingLevel: json["ironing_level"] == null
      //     ? null
      //     : ClothesReturned.fromJson(json["ironing_level"]),
      // starchLevel: json["starch_level"] == null
      //     ? null
      //     : ClothesReturned.fromJson(json["starch_level"]),
      // clothesReturned: json["clothes_returned"] == null
      //     ? null
      //     : ClothesReturned.fromJson(json["clothes_returned"]),
      user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      rider: json["rider"],
      bookingDetail: json["booking_detail"] == null
          ? []
          : List<BookingDetail>.from(
              json["booking_detail"]!.map((x) => BookingDetail.fromJson(x)),
            ),
      pickupSlot: json["pickup_slot"] == null
          ? null
          : SlotModel.fromJson(json["pickup_slot"]),
      deliverySlot: json["delivery_slot"] == null
          ? null
          : SlotModel.fromJson(json["delivery_slot"]),
    );
  }
}

class BookingDetail {
  BookingDetail({
    required this.id,
    required this.bookingId,
    required this.serviceId,
    required this.quantity,
    required this.amount,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
  });

  final int? id;
  final int? bookingId;
  final int? serviceId;
  final int? quantity;
  final String? amount;
  final String? totalAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Service? service;

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      id: json["id"],
      bookingId: json["booking_id"],
      serviceId: json["service_id"],
      quantity: json["quantity"],
      amount: json["amount"],
      totalAmount: json["total_amount"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      service: json["service"] == null
          ? null
          : Service.fromJson(json["service"]),
    );
  }
}

class Service {
  Service({
    required this.id,
    required this.categoryId,
    required this.type,
    required this.title,
    required this.description,
    required this.amount,
    required this.code,
    required this.image,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? categoryId;
  final String? type;
  final String? title;
  final String? description;
  final String? amount;
  final String? code;
  final String? image;
  final int? isActive;
  final dynamic createdAt;
  final dynamic updatedAt;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      categoryId: json["category_id"],
      type: json["type"],
      title: Utils.capitalize(json["title"]),
      description: json["description"],
      amount: json["amount"],
      code: json["code"],
      image: json["image"],
      isActive: json["is_active"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}
