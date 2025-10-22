import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/network/api_response.dart';
import 'package:sanam_laundry/data/models/user.dart';
import 'package:sanam_laundry/data/services/endpoints.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  /// 🔹 LOGIN
  Future<UserModel?> login({required String phone}) async {
    return ApiResponseHandler.handleRequest<UserModel>(
      showErrorToast: false,
      () => _apiService.post(
        Endpoints.login,
        data: {'phone': phone},
        config: const ApiRequestConfig(
          requiresAuth: false,
          showErrorToast: false,
        ),
      ),
      // onSuccess: (data) {
      //   // Some APIs wrap user inside "data" or "user" — handle both cases safely
      //   final userData = data['user'] ?? data['data'] ?? data;
      //   return UserModel.fromJson(userData);
      // },
      onError: (error) => {throw error},
    );
  }

  /// 🔹 REGISTER
  Future<UserModel?> register({
    required String first_name,
    required String email,
    required String last_name,
    required String phone,
    String? gender,
    // required String profileImage,
  }) async {
    return await ApiResponseHandler.handleRequest<UserModel>(
      showErrorToast: false,
      () => _apiService.post(
        Endpoints.register,
        data: {
          'first_name': first_name,
          'email': email,
          'last_name': last_name,
          'phone': phone,
          'gender': gender,
          // 'profile_image': profileImage,
        },
        config: const ApiRequestConfig(requiresAuth: false),
      ),
      // onSuccess: (data) {
      //   final userData = data['user'] ?? data['data'] ?? data;
      //   return UserModel.fromJson(userData);
      // },
    );
  }

  /// 🔹 PROFILE
  Future<UserModel?> getProfile() async {
    return await ApiResponseHandler.handleRequest<UserModel>(
      () => _apiService.get(
        Endpoints.profile,
        config: const ApiRequestConfig(requiresAuth: true, showLoader: true),
      ),
      onSuccess: (data) => UserModel.fromJson(data),
    );
  }

  /// 🔹 REFRESH TOKEN
  Future<void> refreshAuthToken() async {
    await ApiResponseHandler.handleRequest(
      () => _apiService.post(
        Endpoints.refreshToken,
        config: const ApiRequestConfig(
          requiresAuth: true,
          showErrorToast: false,
        ),
      ),
      showErrorToast: false,
    );
  }
}
