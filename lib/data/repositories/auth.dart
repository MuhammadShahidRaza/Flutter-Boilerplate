import 'package:image_picker/image_picker.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/network/api_response.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/services/endpoints.dart';
import 'package:sanam_laundry/providers/auth.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<String?> login(Map<String, dynamic> data) async {
    String? message;

    await ApiResponseHandler.handleRequest(
      () => _apiService.post(
        Endpoints.login,
        data: data,
        config: ApiRequestConfig(requiresAuth: false, showErrorToast: false),
      ),
      onSuccess: (data, statusCode) {
        if (statusCode == 200) {
          message = "loginSuccessful";
        }
      },
      onError: (error, statusCode) {
        if (statusCode == 404) {
          message = "userNotFound";
        } else if (statusCode == 403) {
          message = "userNotVerified";
        } else {
          message = error.toString();
        }
      },
    );
    return message;
  }

  /// 🔹 REGISTER
  Future register({
    required String firstName,
    required String email,
    required String lastName,
    required String phone,
    String? gender,
    XFile? profileImage,
  }) async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.multipartPost(
        Endpoints.register,
        data: {
          'first_name': firstName,
          'email': email,
          'last_name': lastName,
          'phone': phone,
          'gender': gender,
          'profile_image': profileImage,
        },
        config: const ApiRequestConfig(requiresAuth: false),
      ),
    );
  }

  /// 🔹 PROFILE
  Future<UserModel?> getProfile() async {
    return await ApiResponseHandler.handleRequest<UserModel>(
      () => _apiService.get(Endpoints.profile),
      onSuccess: (data, _) {
        final userData = data['user'];
        return UserModel.fromJson(userData);
      },
    );
  }

  Future deleteAccount() {
    return ApiResponseHandler.handleRequest(
      () => _apiService.delete(
        Endpoints.deleteAccount,
        config: const ApiRequestConfig(showErrorToast: false, showLoader: true),
      ),
    );
  }

  Future<void> logout() async {
    await ApiResponseHandler.handleRequest(
      () => _apiService.post(
        Endpoints.logout,
        data: {"udid": "132323"},
        config: const ApiRequestConfig(showErrorToast: false),
      ),
      onSuccess: (data, statusCode) async {
        await AuthProvider().logout();
      },
    );
  }

  /// 🔹 VERIFY OTP
  Future<UserModel?> verifyOtp({
    required String phone,
    required String otp,
    required String deviceToken,
  }) async {
    return await ApiResponseHandler.handleRequest<UserModel>(
      () => _apiService.post(
        Endpoints.verifyOtp,
        data: {
          'phone': phone,
          'otp': otp,
          // device_type:Testing Tool
          "device_token": deviceToken,
          // udid:123456789
          // device_brand:Postman
          // device_os:Linux
          // app_version:1.0.0
        },
        config: const ApiRequestConfig(requiresAuth: false),
      ),
      onSuccess: (data, _) {
        final userData = data['user'];
        return UserModel.fromJson(userData);
      },
    );
  }

  Future<UserModel?> resendCode({required String phone}) async {
    return ApiResponseHandler.handleRequest<UserModel>(
      () => _apiService.post(
        Endpoints.login,
        data: {'phone': phone},
        config: const ApiRequestConfig(
          requiresAuth: false,
          showErrorToast: false,
        ),
      ),
    );
  }

  /// 🔹 EDIT PROFILE
  Future editProfile({
    required String firstName,
    required String lastName,
    String? gender,
    XFile? profileImage,
  }) async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.multipartPost(
        Endpoints.updateUserProfile,
        data: {
          "_method": "PATCH",
          'first_name': firstName,
          'last_name': lastName,
          ...(gender != null ? {'gender': gender} : {}),
          ...(profileImage != null ? {'profile_image': profileImage} : {}),
        },
      ),
      onSuccess: (data, _) {
        final userData = data['user'];
        return UserModel.fromJson(userData);
      },
    );
  }

  /// 🔹 CONTACT US
  Future contactUs({
    required String fullName,
    required String email,
    required String description,
    required String phone,
  }) async {
    return await ApiResponseHandler.handleRequest(
      () => _apiService.post(
        Endpoints.contactUs,
        data: {
          'name': fullName,
          'email': email,
          'phone': phone,
          'description': description,
        },
        // config: const ApiRequestConfig(showSuccessToast: true),
      ),
    );
  }

  Future<StaticPageModel?> privacyPolicy(name) async {
    final endpoint = switch (name) {
      Common.termsAndConditions => Endpoints.termsAndConditions,
      Common.privacyPolicy => Endpoints.privacyPolicy,
      _ => Endpoints.privacyPolicy,
    };

    return await ApiResponseHandler.handleRequest(
      () => _apiService.get(
        endpoint,
        config: const ApiRequestConfig(showErrorToast: false),
      ),
      onSuccess: (data, _) => StaticPageModel.fromJson(data),
    );
  }
}
