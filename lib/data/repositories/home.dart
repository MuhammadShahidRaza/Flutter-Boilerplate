import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/network/api_response.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/models/address.dart';
import 'package:sanam_laundry/data/models/service.dart';
import 'package:sanam_laundry/data/services/endpoints.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();

  /// 🔹 BANNERS
  Future getBannners() async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.get(Endpoints.banners),
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
      () => _apiService.get(Endpoints.categories),
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
      () => _apiService.get(Endpoints.addresses),
      onSuccess: (data, _) {
        final list = Utils.safeList(
          data["addresses"],
        ).map((e) => AddressModel.fromJson(e)).toList();
        return list;
      },
    );
  }

  Future<List<ServiceItemModel>?> getServicesByCategoryId(
    String categoryId, {
    String type = "services",
  }) async {
    return await ApiResponseHandler.handleRequest<List<ServiceItemModel>>(
      () => _apiService.get(
        Endpoints.services,
        query: {'category_id': categoryId, 'type': type},
      ),
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
      () => _apiService.post(
        Endpoints.addAddress,
        data: address,
        config: const ApiRequestConfig(showSuccessToast: true),
      ),
      onSuccess: (data, _) {
        final address = data['addresses'];
        return AddressModel.fromJson(address);
      },
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
  //       Endpoints.updateUserProfile,
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

  /// 🔹 CONTACT US
  // Future contactUs({
  //   required String fullName,
  //   required String email,
  //   required String description,
  //   required String phone,
  // }) async {
  //   return await ApiResponseHandler.handleRequest(
  //     () => _apiService.post(
  //       Endpoints.contactUs,
  //       data: {
  //         'name': fullName,
  //         'email': email,
  //         'phone': phone,
  //         'description': description,
  //       },
  //       // config: const ApiRequestConfig(showSuccessToast: true),
  //     ),
  //   );
  // }
}
