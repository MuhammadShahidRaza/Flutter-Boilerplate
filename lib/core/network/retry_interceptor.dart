import 'dart:async';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
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
    // Retry only on network timeout / server errors
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}
