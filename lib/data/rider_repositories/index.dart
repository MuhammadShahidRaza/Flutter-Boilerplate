import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/network/api_response.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/models/address.dart';
import 'package:sanam_laundry/data/models/notification.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/data/models/paginated.dart';
import 'package:sanam_laundry/data/models/service.dart';
import 'package:sanam_laundry/data/models/settings.dart';
import 'package:sanam_laundry/data/models/slot.dart';
import 'package:sanam_laundry/data/services/rider_endpoints.dart';
import 'package:sanam_laundry/presentation/screens/rider/my_jobs.dart';
import 'package:sanam_laundry/providers/index.dart';

class RiderRepository {
  final ApiService _apiService = ApiService();

  Future<UserModel?> login(Map<String, dynamic> data) async {
    return await ApiResponseHandler.handleRequest<UserModel>(
      () => _apiService.post(
        RiderEndpoints.login,
        data: data,
        config: ApiRequestConfig(requiresAuth: false),
      ),
      onSuccess: (data, _) {
        final userData = data['user'];
        return UserModel.fromJson(userData);
      },
    );
  }

  /// 🔹 BANNERS
  Future getBannners() async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.get(RiderEndpoints.banners),
      onSuccess: (data, _) {
        final banners = Utils.safeList(data?["banners"]);
        final list = banners
            .map((e) => BannerModel.fromJson(e).media)
            .where((x) => x.isNotEmpty)
            .toList();

        return list;
      },
    );
  }

  Future<List<CategoryModel>?> getCategories() async {
    return await ApiResponseHandler.handleRequest<List<CategoryModel>>(
      () => _apiService.get(RiderEndpoints.categories),
      onSuccess: (data, _) {
        final list = Utils.safeList(
          data,
        ).map((e) => CategoryModel.fromJson(e)).toList();
        return list;
      },
    );
  }

  Future<List<AddressModel>?> getAddresses() async {
    return await ApiResponseHandler.handleRequest<List<AddressModel>>(
      () => _apiService.get(
        RiderEndpoints.addresses,
        config: ApiRequestConfig(showLoader: true),
      ),
      onSuccess: (data, _) {
        final addresses = data?["addresses"];
        final list = Utils.safeList(
          addresses,
        ).map((e) => AddressModel.fromJson(e)).toList();
        return list;
      },
    );
  }

  Future getSettings() async {
    return await ApiResponseHandler.handleRequest<SettingsModel>(
      () => _apiService.get(RiderEndpoints.settings),
      onSuccess: (data, statusCode) => SettingsModel.fromJson(data),
    );
  }

  Future getSlots() async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.get(RiderEndpoints.slots),
      onSuccess: (data, _) {
        final list = Utils.safeList(
          data,
        ).map((e) => SlotModel.fromJson(e)).toList();
        return list;
      },
    );
  }

  Future additionalInfo() async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.get(
        RiderEndpoints.additionalInfo,
        config: ApiRequestConfig(showLoader: true),
      ),
      onSuccess: (data, _) {
        return data ?? [];
        // final list = Utils.safeList(
        //   data["slots"],
        // ).map((e) => SlotModel.fromJson(e)).toList();
        // return list;
      },
    );
  }

  Future<List<ServiceItemModel>?> getServicesByCategoryId(
    String? categoryId, {
    String type = "services",
  }) async {
    final Map<String, String> query = {"type": type};

    // Add only if categoryId is valid
    if (categoryId != null && categoryId.isNotEmpty) {
      query["category_id"] = categoryId;
    }

    return await ApiResponseHandler.handleRequest<List<ServiceItemModel>>(
      () => _apiService.get(RiderEndpoints.services, query: query),
      onSuccess: (data, _) {
        final list = Utils.safeList(
          data["services"],
        ).map((e) => ServiceItemModel.fromJson(e)).toList();
        return list;
      },
    );
  }

  Future<AddressModel?> addNewAddress(address) async {
    return await ApiResponseHandler.handleRequest<AddressModel>(
      () => _apiService.multipartPost(
        RiderEndpoints.addAddress,
        data: address,
        config: const ApiRequestConfig(showSuccessToast: true),
      ),
      onSuccess: (data, _) {
        final address = data['address'];
        return AddressModel.fromJson(address);
      },
    );
  }

  Future<AddressModel?> updateAddress({address, id}) async {
    return await ApiResponseHandler.handleRequest<AddressModel>(
      () => _apiService.multipartPost(
        "${RiderEndpoints.updateAddress}/$id",
        data: address,
        config: const ApiRequestConfig(showSuccessToast: true),
      ),
      onSuccess: (data, _) {
        final address = data['address'];
        return AddressModel.fromJson(address);
      },
    );
  }

  Future deleteAddress(int id) async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.delete(
        '${RiderEndpoints.addresses}/$id',
        config: const ApiRequestConfig(showSuccessToast: true),
      ),
    );
  }

  /// 🔹 VERIFY OTP

  /// 🔹 EDIT PROFILE
  // Future editProfile({
  //   required String firstName,
  //   required String lastName,
  //   String? gender,
  //   XFile? profileImage,
  // }) async {
  //   return await ApiResponseHandler.handleRequest(
  //     () => _apiService.multipartPost(
  //       RiderEndpoints.updateUserProfile,
  //       data: {
  //         "_method": "PATCH",
  //         'first_name': firstName,
  //         'last_name': lastName,
  //         ...(gender != null ? {'gender': gender} : {}),
  //         ...(profileImage != null ? {'profile_image': profileImage} : {}),
  //       },
  //     ),
  //     onSuccess: (data, _) {
  //       final userData = data['user'];
  //       return UserModel.fromJson(userData);
  //     },
  //   );
  // }

  /// 🔹 EDIT PROFILE
  Future editProfile({XFile? profileImage}) async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.multipartPost(
        RiderEndpoints.updateUserProfile,
        data: {
          "_method": "PATCH",
          ...(profileImage != null ? {'profile_image': profileImage} : {}),
        },
      ),
      onSuccess: (data, _) {
        final userData = data['user'];
        return UserModel.fromJson(userData);
      },
    );
  }

  Future<void> logout() async {
    final token = await FirebaseMessaging.instance.getToken();
    await ApiResponseHandler.handleRequest(
      () => _apiService.post(
        RiderEndpoints.logout,
        data: {"udid": token ?? ""},
        config: const ApiRequestConfig(showErrorToast: false),
      ),
      onSuccess: (data, statusCode) async {
        await AuthProvider().logout();
      },
    );
  }

  Future placeOrder({required Map<String, dynamic> payload}) async {
    debugPrint(payload.toString());
    return await ApiResponseHandler.handleRequest(
      () => _apiService.multipartPost(
        RiderEndpoints.createOrder,
        data: payload,
        config: const ApiRequestConfig(showLoader: true),
      ),
      // onSuccess: (data, _) {
      //   return OrderModel.fromJson(data);
      // },
    );
  }

  Future<PaginatedResult<OrderModel>?> getOrders({
    type,
    slotId,
    status,
    search,
    int page = 1,
  }) async {
    final query = {"type": type, "slot_id": slotId, "page": page};
    if (status == JobStatus.completed.label) {
      query["completed"] = true;
    } else if (status == JobStatus.ordersInVehicle.label) {
      query["order_in_vehicle"] = true;
    } else if (status != null) {
      // query["status"] = status;
    }
    if (search != null && search.isNotEmpty) {
      query["search"] = search;
    }
    return await ApiResponseHandler.handleRequest<PaginatedResult<OrderModel>>(
      () => _apiService.get(RiderEndpoints.getOrders, query: query),
      onSuccess: (data, _) {
        return PaginatedResult<OrderModel>.fromJson(
          data,
          itemsKey: 'bookings',
          itemsParser: (raw) {
            final bookings = Utils.safeList(raw);
            return bookings.map((e) => OrderModel.fromJson(e)).toList();
          },
        );
      },
    );
  }

  Future getHomeOrders({type, slotId}) async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.get(
        RiderEndpoints.getHomeOrders,
        query: {"type": type, "slot_id": slotId},
      ),
      onSuccess: (data, _) {
        final orders = Utils.safeList(data?["bookings"]);
        final list = orders.map((e) => OrderModel.fromJson(e)).toList();
        return {"orders": list, "info": data?["rider_info"]};
      },
    );
  }

  Future<PaginatedResult<NotificationModel>?> getNotifications({
    int page = 1,
  }) async {
    return await ApiResponseHandler.handleRequest<
      PaginatedResult<NotificationModel>
    >(
      () => _apiService.get(
        RiderEndpoints.notifications,
        query: {"page": page},
        // config: ApiRequestConfig(showLoader: page == 1),
      ),
      onSuccess: (data, _) {
        return PaginatedResult<NotificationModel>.fromJson(
          data,
          itemsKey: 'notify',
          itemsParser: (raw) {
            final list = Utils.safeList(raw);
            return list.map((e) => NotificationModel.fromJson(e)).toList();
          },
        );
      },
    );
  }

  Future getOrderDetailsById(String id) async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.get('${RiderEndpoints.getOrders}/$id'),
      onSuccess: (data, _) => OrderModel.fromJson(data),
    );
  }

  Future updateRiderActiveStatus({
    required bool isActive,
    LatLng? location,
  }) async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.multipartPost(
        RiderEndpoints.updateUserProfile,
        data: {
          "_method": "PATCH",
          'is_rider_active': isActive ? 1 : 0,
          if (location != null) ...{
            'latitude': location.latitude,
            'longitude': location.longitude,
          },
        },
      ),
      onSuccess: (data, _) {
        final userData = data['user'];
        return UserModel.fromJson(userData);
      },
    );
  }

  Future updateOrderStatus({
    required String status,
    required String id,
    XFile? image,
  }) async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.multipartPost(
        "${RiderEndpoints.updateOrder}$id/update-status",
        data: {
          "_method": "PATCH",
          "status": status,
          ...(image != null ? {'media': image} : {}),
        },
        config: const ApiRequestConfig(showLoader: true),
      ),
      onSuccess: (data, _) {
        return OrderModel.fromJson(data);
      },
    );
  }
}
