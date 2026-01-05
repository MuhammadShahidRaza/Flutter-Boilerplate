import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioExceptions implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final DioExceptionType? type;

  DioExceptions({required this.message, this.statusCode, this.data, this.type});

  factory DioExceptions.fromDioError(DioException dioError) {
    final statusCode = dioError.response?.statusCode;
    final responseData = dioError.response?.data;

    // Log technical info for debugging (never shown to users)
    if (kDebugMode) {
      debugPrint('⚠️ DioError Type: ${dioError.type}');
      debugPrint('📡 Status Code: $statusCode');
      debugPrint('🧩 Response: $responseData');
      debugPrint('💥 Error: ${dioError.error}');
    }

    // Friendly messages for users
    const defaultMessage = 'Something went wrong. Please try again later.';

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DioExceptions(
          message: 'Please check your internet connection and try again.',
          type: dioError.type,
        );

      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
        // return DioExceptions(
        //   message: _mapStatusCodeToMessage(statusCode) ?? defaultMessage,
        //   statusCode: statusCode,
        //   type: dioError.type,
        // );

        final extracted = extractMessage(responseData);
        return DioExceptions(
          message:
              extracted ??
              _mapStatusCodeToMessage(statusCode) ??
              defaultMessage,
          statusCode: statusCode,
          data: responseData,
          type: dioError.type,
        );

      case DioExceptionType.cancel:
        return DioExceptions(
          message: 'Request was cancelled. Please try again.',
          type: dioError.type,
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return DioExceptions(
            message: 'Please check your network connection.',
            type: dioError.type,
          );
        }
        return DioExceptions(message: defaultMessage, type: dioError.type);
    }
  }

  static String? _mapStatusCodeToMessage(int? code) {
    switch (code) {
      case 400:
        return 'Invalid request. Please try again.';
      case 401:
        return 'Session expired. Please log in again.';
      case 403:
        return 'Access denied. You don’t have permission.';
      case 404:
        return 'Requested resource not found.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server is temporarily unavailable. Please try again later.';
      default:
        return null;
    }
  }

  static String? extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      const possibleKeys = [
        'message',
        'messages',
        'msg',
        'error',
        'detail',
        'title',
        'errors',
      ];
      for (final key in possibleKeys) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) return value;
      }

      for (final value in data.values) {
        final nested = extractMessage(value);
        if (nested != null && nested.isNotEmpty) return nested;
      }
    } else if (data is List) {
      for (final item in data) {
        final nested = extractMessage(item);
        if (nested != null && nested.isNotEmpty) return nested;
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return null;
  }

  bool get isUnauthorized => statusCode == 401;

  bool get isNetworkError =>
      type == DioExceptionType.connectionError ||
      type == DioExceptionType.unknown;

  @override
  String toString() => message;
}
