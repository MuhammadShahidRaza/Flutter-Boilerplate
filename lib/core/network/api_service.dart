import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
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

  // Future<Response<T>> multipartPost<T>(
  //   String path, {
  //   required FormData data,
  //   Options? options,
  //   ApiRequestConfig config = const ApiRequestConfig(),
  // }) async {
  //   final resolvedOptions = ApiClient.applyConfig(
  //     config: config,
  //     options: options,
  //   );
  //   return _dio.post<T>(path, data: data, options: resolvedOptions);
  // }

  // Future<Response<T>> multipartPost<T>(
  //   String path, {
  //   required Map<String, dynamic> data,
  //   Options? options,
  //   ApiRequestConfig config = const ApiRequestConfig(),
  // }) async {
  //   // Convert the map into FormData
  //   final formData = FormData();

  //   for (final entry in data.entries) {
  //     final key = entry.key;
  //     final value = entry.value;

  //     if (value == null) continue;

  //     // If value is a File, XFile, or MultipartFile — handle properly
  //     if (value is MultipartFile) {
  //       formData.fields.add(MapEntry(key, value));
  //     } else if (value is List<MultipartFile>) {
  //       // handle list of files
  //       for (final file in value) {
  //         formData.files.add(MapEntry(key, file));
  //       }
  //     } else if (value is XFile) {
  //       formData.files.add(
  //         MapEntry(
  //           key,
  //           await MultipartFile.fromFile(value.path, filename: value.name),
  //         ),
  //       );
  //     } else {
  //       // Add regular field
  //       formData.fields.add(MapEntry(key, value.toString()));
  //     }
  //   }

  //   // Merge any existing headers with multipart header
  //   final multipartOptions = (options ?? Options()).copyWith(
  //     headers: {...?options?.headers, 'Content-Type': 'multipart/form-data'},
  //   );

  //   // Apply API client config (auth, loader, etc.)
  //   final resolvedOptions = ApiClient.applyConfig(
  //     config: config,
  //     options: multipartOptions,
  //   );

  //   return _dio.post<T>(path, data: formData, options: resolvedOptions);
  // }

  Future<Response<T>> multipartPost<T>(
    String path, {
    required Map<String, dynamic> data,
    Options? options,
    ApiRequestConfig config = const ApiRequestConfig(),
  }) async {
    final formData = FormData();

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;

      // ✅ Single MultipartFile or File/XFile
      if (value is MultipartFile) {
        formData.files.add(MapEntry(key, value));
      } else if (value is XFile) {
        formData.files.add(
          MapEntry(
            key,
            await MultipartFile.fromFile(value.path, filename: value.name),
          ),
        );
      } else if (value is File) {
        formData.files.add(
          MapEntry(
            key,
            await MultipartFile.fromFile(
              value.path,
              filename: value.path.split('/').last,
            ),
          ),
        );
      }
      // ✅ Multiple files (List of File, XFile, or MultipartFile)
      else if (value is List) {
        for (final v in value) {
          if (v is MultipartFile) {
            formData.files.add(MapEntry(key, v));
          } else if (v is XFile) {
            formData.files.add(
              MapEntry(
                key,
                await MultipartFile.fromFile(v.path, filename: v.name),
              ),
            );
          } else if (v is File) {
            formData.files.add(
              MapEntry(
                key,
                await MultipartFile.fromFile(
                  v.path,
                  filename: v.path.split('/').last,
                ),
              ),
            );
          } else {
            // Non-file value inside list — just add as string
            formData.fields.add(MapEntry(key, v.toString()));
          }
        }
      }
      // ✅ Regular field (String, int, etc.)
      else {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    }

    // Merge any existing headers with multipart header
    final multipartOptions = (options ?? Options()).copyWith(
      headers: {...?options?.headers, 'Content-Type': 'multipart/form-data'},
    );

    // Apply API client config (auth, loader, etc.)
    final resolvedOptions = ApiClient.applyConfig(
      config: config,
      options: multipartOptions,
    );

    return _dio.post<T>(path, data: formData, options: resolvedOptions);
  }
}
