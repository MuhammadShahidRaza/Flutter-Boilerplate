import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.retries = 1,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      var attempt = 0;
      while (attempt < retries) {
        attempt++;
        try {
          await Future.delayed(retryDelay * attempt); // exponential backoff
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (_) {
          if (attempt == retries) return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Only retry idempotent requests
    final method = err.requestOptions.method.toUpperCase();
    final isIdempotent =
        method == 'GET' || method == 'HEAD' || method == 'OPTIONS';

    if (!isIdempotent) return false;

    // Retry on network timeouts, transient server errors, and certain connection resets
    final statusCode = err.response?.statusCode ?? 0;
    final isServerError = statusCode >= 500;

    final isTimeout =
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;

    final isConnectionReset =
        err.type == DioExceptionType.unknown ||
        err.type == DioExceptionType.connectionError;

    final cause = err.error;
    final isHttpException = cause is HttpException;

    return isTimeout || isServerError || (isConnectionReset && isHttpException);
  }
}
