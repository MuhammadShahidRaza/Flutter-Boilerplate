import 'package:dio/dio.dart';
import 'package:sanam_laundry/core/network/api_client.dart';
import 'package:sanam_laundry/core/network/api_request_config.dart';

class ApiService {
  ApiService({Dio? dio}) : _dio = dio ?? ApiClient.instance;

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
    ApiRequestConfig config = const ApiRequestConfig(),
  }) async {
    final resolvedOptions = ApiClient.applyConfig(
      config: config,
      options: options,
    );
    return _dio.get<T>(path, queryParameters: query, options: resolvedOptions);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
    ApiRequestConfig config = const ApiRequestConfig(),
  }) async {
    final resolvedOptions = ApiClient.applyConfig(
      config: config,
      options: options,
    );
    return _dio.post<T>(path, data: data, options: resolvedOptions);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
    ApiRequestConfig config = const ApiRequestConfig(),
  }) async {
    final resolvedOptions = ApiClient.applyConfig(
      config: config,
      options: options,
    );
    return _dio.put<T>(path, data: data, options: resolvedOptions);
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
    ApiRequestConfig config = const ApiRequestConfig(),
  }) async {
    final resolvedOptions = ApiClient.applyConfig(
      config: config,
      options: options,
    );
    return _dio.patch<T>(path, data: data, options: resolvedOptions);
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    ApiRequestConfig config = const ApiRequestConfig(),
  }) async {
    final resolvedOptions = ApiClient.applyConfig(
      config: config,
      options: options,
    );
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: query,
      options: resolvedOptions,
    );
  }

  Future<Response<T>> multipartPost<T>(
    String path, {
    required FormData data,
    Options? options,
    ApiRequestConfig config = const ApiRequestConfig(),
  }) async {
    final resolvedOptions = ApiClient.applyConfig(
      config: config,
      options: options,
    );
    return _dio.post<T>(path, data: data, options: resolvedOptions);
  }
}
