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
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.status,
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
    required this.ironingLevel,
    required this.starchLevel,
    required this.clothesReturned,
    required this.user,
    required this.rider,
    required this.bookingDetail,
  });

  final int? id;
  final int? userId;
  final dynamic riderId;
  final int? zoneId;
  final String? deliveryType;
  final DateTime? pickupDatetime;
  final int? pickupSlotId;
  final DateTime? deliveryDatetime;
  final int? deliverySlotId;
  final String? address;
  final String? city;
  final String? state;
  final String? latitude;
  final String? longitude;
  final String status;
  final String? paymentStatus;
  final String? subTotal;
  final String? tax;
  final String? deliveryCharges;
  final String? totalAmount;
  final dynamic paymentMethod;
  final dynamic transactionId;
  final dynamic transactionReference;
  final String specialInstructions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? ironingId;
  final int? starchId;
  final int? clothesReturnedId;
  final ClothesReturned? ironingLevel;
  final ClothesReturned? starchLevel;
  final ClothesReturned? clothesReturned;
  final User? user;
  final dynamic rider;
  final List<BookingDetail> bookingDetail;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      userId: json["user_id"],
      riderId: json["rider_id"],
      zoneId: json["zone_id"],
      deliveryType: json["delivery_type"],
      pickupDatetime: DateTime.tryParse(json["pickup_datetime"] ?? ""),
      pickupSlotId: json["pickup_slot_id"],
      deliveryDatetime: DateTime.tryParse(json["delivery_datetime"] ?? ""),
      deliverySlotId: json["delivery_slot_id"],
      address: json["address"],
      city: json["city"],
      state: json["state"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      status: json["status"],
      paymentStatus: json["payment_status"],
      subTotal: json["sub_total"],
      tax: json["tax"],
      deliveryCharges: json["delivery_charges"],
      totalAmount: json["total_amount"],
      paymentMethod: json["payment_method"],
      transactionId: json["transaction_id"],
      transactionReference: json["transaction_reference"],
      specialInstructions: json["special_instructions"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      ironingId: json["ironing_id"],
      starchId: json["starch_id"],
      clothesReturnedId: json["clothes_returned_id"],
      ironingLevel: json["ironing_level"] == null
          ? null
          : ClothesReturned.fromJson(json["ironing_level"]),
      starchLevel: json["starch_level"] == null
          ? null
          : ClothesReturned.fromJson(json["starch_level"]),
      clothesReturned: json["clothes_returned"] == null
          ? null
          : ClothesReturned.fromJson(json["clothes_returned"]),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      rider: json["rider"],
      bookingDetail: json["booking_detail"] == null
          ? []
          : List<BookingDetail>.from(
              json["booking_detail"]!.map((x) => BookingDetail.fromJson(x)),
            ),
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
      title: json["title"],
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

class ClothesReturned {
  ClothesReturned({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int? id;
  final String? title;
  final String? type;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;

  factory ClothesReturned.fromJson(Map<String, dynamic> json) {
    return ClothesReturned(
      id: json["id"],
      title: json["title"],
      type: json["type"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      deletedAt: json["deleted_at"],
    );
  }
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.providerId,
    required this.provider,
    required this.countryCode,
    required this.bio,
    required this.userType,
    required this.userRole,
    required this.customerId,
    required this.zoneId,
    required this.profileImage,
    required this.gender,
    required this.dob,
    required this.address,
    required this.city,
    required this.zipcode,
    required this.latitude,
    required this.longitude,
    required this.isRiderActive,
    required this.riderLoginTime,
    required this.status,
    required this.note,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final dynamic providerId;
  final dynamic provider;
  final dynamic countryCode;
  final dynamic bio;
  final String? userType;
  final String? userRole;
  final String? customerId;
  final dynamic zoneId;
  final dynamic profileImage;
  final String? gender;
  final dynamic dob;
  final dynamic address;
  final dynamic city;
  final dynamic zipcode;
  final dynamic latitude;
  final dynamic longitude;
  final int? isRiderActive;
  final dynamic riderLoginTime;
  final int? status;
  final dynamic note;
  final String? language;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      phone: json["phone"],
      providerId: json["provider_id"],
      provider: json["provider"],
      countryCode: json["country_code"],
      bio: json["bio"],
      userType: json["user_type"],
      userRole: json["user_role"],
      customerId: json["customer_id"],
      zoneId: json["zone_id"],
      profileImage: json["profile_image"],
      gender: json["gender"],
      dob: json["dob"],
      address: json["address"],
      city: json["city"],
      zipcode: json["zipcode"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      isRiderActive: json["is_rider_active"],
      riderLoginTime: json["rider_login_time"],
      status: json["status"],
      note: json["note"],
      language: json["language"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}
