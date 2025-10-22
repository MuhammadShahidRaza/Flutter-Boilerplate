import 'package:dio/dio.dart';
import 'package:sanam_laundry/core/index.dart';

class ApiResponseHandler {
  ApiResponseHandler._();

  /// Generic method for handling API calls safely
  static Future<T?> handleRequest<T>(
    Future<Response> Function() request, {
    T Function(dynamic data)? onSuccess,
    void Function(DioExceptions error)? onError,
    bool showErrorToast = true,
  }) async {
    try {
      final response = await request();

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        return onSuccess != null ? onSuccess(data) : data;
      } else {
        final message =
            DioExceptions.extractMessage(response.data) ??
            'Unexpected error occurred.';
        if (showErrorToast) AppToast.showToast(message, isError: true);
        return null;
      }
    } on DioException catch (e) {
      final error = DioExceptions.fromDioError(e);
      if (showErrorToast) AppToast.showToast(error.message, isError: true);
      if (onError != null) onError(error);
      return null;
    } catch (e) {
      if (showErrorToast) {
        AppToast.showToast('Something went wrong', isError: true);
      }
      return null;
    }
  }
}
