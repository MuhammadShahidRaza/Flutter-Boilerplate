import 'package:dio/dio.dart';
import 'package:sanam_laundry/core/index.dart';

class ApiResponseHandler {
  ApiResponseHandler._();

  static Future<T?> handleRequest<T>(
    Future<Response> Function() request, {
    T Function(dynamic data, int? statusCode)? onSuccess,
    T Function(DioExceptions error, int? statusCode)? onError,
  }) async {
    try {
      final response = await request();
      final parsedData = _extractResponseData(response.data);
      return onSuccess != null
          ? onSuccess(parsedData, response.statusCode)
          : parsedData;
    } on DioException catch (e) {
      final error = DioExceptions.fromDioError(e);
      final statusCode = e.response?.statusCode;
      if (onError != null) return onError(error, statusCode);
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Extracts the correct portion of API response
  static dynamic _extractResponseData(dynamic response) {
    if (response is Map && response.containsKey('response')) {
      final inner = response['response'];

      if (inner is Map && inner.containsKey('data')) {
        final data = inner['data'];

        // ✅ return data only if not empty
        if (data is List && data.isNotEmpty) return data;
        if (data is Map && data.isNotEmpty) return data;

        // ✅ fallback: return full inner response
        return inner;
      }

      return inner;
    }

    return response;
  }
}
