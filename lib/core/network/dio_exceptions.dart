import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        message = "Connection Timeout";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive Timeout";
        break;
      case DioExceptionType.badResponse:
        message = dioError.response?.data["message"] ?? "Something went wrong";
        break;
      case DioExceptionType.unknown:
        message = "No Internet connection";
        break;
      default:
        message = "Unexpected error occurred";
        break;
    }
  }

  @override
  String toString() => message;
}
