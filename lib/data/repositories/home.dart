import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/network/api_response.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/services/endpoints.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();

  /// 🔹 PROFILE
  Future getBannners() async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.get(Endpoints.banners),
      onSuccess: (data, _) {
        final banners = data["banners"] as List;

        final list = banners.map((e) => (e["media"] ?? "").toString()).toList();

        return list;
      },
    );
  }

  Future<List<CategoryModel>?> getCategories() async {
    return await ApiResponseHandler.handleRequest<List<CategoryModel>>(
      () => _apiService.get(Endpoints.categories),
      onSuccess: (data, _) {
        // `data` is list<dynamic> coming from API
        final list = (data as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();

        return list;
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
