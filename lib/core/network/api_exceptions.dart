import 'dart:io';
import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions({required this.message, this.statusCode, this.data, this.type});

  final String message;
  final int? statusCode;
  final dynamic data;
  final DioExceptionType? type;

  factory DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DioExceptions(
          message: 'Connection timeout. Please try again.',
          type: dioError.type,
        );
      case DioExceptionType.badCertificate:
        return DioExceptions(
          message: 'Cannot verify server certificate.',
          type: dioError.type,
        );
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        final responseData = dioError.response?.data;
        return DioExceptions(
          message:
              extractMessage(responseData) ??
              'Oops! Something went wrong. Please try again.',
          statusCode: statusCode,
          data: responseData,
          type: dioError.type,
        );
      case DioExceptionType.cancel:
        return DioExceptions(
          message: 'Request cancelled.',
          type: dioError.type,
        );
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return DioExceptions(
            message: 'No internet connection. Please check your network.',
            type: dioError.type,
          );
        }
        return DioExceptions(
          message: 'Unexpected error occurred. Please try again later.',
          type: dioError.type,
        );
    }
  }

  bool get isUnauthorized => statusCode == 401;

  bool get isNetworkError =>
      type == DioExceptionType.connectionError ||
      type == DioExceptionType.unknown;

  static String? extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      const possibleKeys = [
        'message',
        'msg',
        'error',
        'errors',
        'detail',
        'title',
      ];

      for (final key in possibleKeys) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }

      for (final value in data.values) {
        final extracted = extractMessage(value);
        if (extracted != null && extracted.isNotEmpty) {
          return extracted;
        }
      }
    } else if (data is List) {
      for (final item in data) {
        final extracted = extractMessage(item);
        if (extracted != null && extracted.isNotEmpty) {
          return extracted;
        }
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return null;
  }

  @override
  String toString() => message;
}
