import 'package:dio/dio.dart'
    show
        BaseOptions,
        Dio,
        DioException,
        ErrorInterceptorHandler,
        Interceptor,
        LogInterceptor,
        Options,
        RequestInterceptorHandler,
        RequestOptions,
        Response,
        ResponseInterceptorHandler;
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:sanam_laundry/core/config/environment.dart';
import 'package:sanam_laundry/core/network/api_exceptions.dart';
import 'package:sanam_laundry/core/network/api_request_config.dart';
// import 'package:sanam_laundry/core/network/retry_interceptor.dart';
import 'package:sanam_laundry/core/utils/toast.dart';
import 'package:sanam_laundry/data/services/auth.dart';

class ApiClient {
  ApiClient._({String? customBaseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: customBaseUrl ?? Environment.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoaderInterceptor(),
      _SuccessInterceptor(),
      _ErrorInterceptor(),
      if (Environment.enableLogs)
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
        ),
      // RetryInterceptor(dio: _dio),
    ]);
  }

  late final Dio _dio;

  static final ApiClient _instance = ApiClient._();
  static Dio get instance => _instance._dio;

  static final ValueNotifier<bool> loaderNotifier = ValueNotifier<bool>(false);
  static int _activeLoaderCount = 0;

  static ApiRequestConfig resolveConfig(RequestOptions options) {
    final config = options.extra[ApiRequestConfig.extraKey];
    if (config is ApiRequestConfig) return config;
    return const ApiRequestConfig();
  }

  static Options applyConfig({
    ApiRequestConfig config = const ApiRequestConfig(),
    Options? options,
  }) {
    final opts = options ?? Options();
    opts.extra ??= <String, dynamic>{};
    opts.extra![ApiRequestConfig.extraKey] = config;
    return opts;
  }

  static void _incrementLoader() {
    _activeLoaderCount++;
    if (!loaderNotifier.value) {
      loaderNotifier.value = true;
    }
  }

  static void _decrementLoader() {
    if (_activeLoaderCount == 0) return;
    _activeLoaderCount--;
    if (_activeLoaderCount == 0) {
      loaderNotifier.value = false;
    }
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final config = ApiClient.resolveConfig(options);
    if (!config.requiresAuth) {
      return handler.next(options);
    }

    final token = await AuthService.loadToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}

class _LoaderInterceptor extends Interceptor {
  static const _loaderKey = '_sanam_loader_enabled';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final config = ApiClient.resolveConfig(options);
    if (config.showLoader) {
      ApiClient._incrementLoader();
      options.extra[_loaderKey] = true;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _complete(response.requestOptions);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _complete(err.requestOptions);
    handler.next(err);
  }

  void _complete(RequestOptions options) {
    final enabled = options.extra[_loaderKey] == true;
    if (enabled) {
      ApiClient._decrementLoader();
      options.extra.remove(_loaderKey);
    }
  }
}

class _SuccessInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final config = ApiClient.resolveConfig(response.requestOptions);
    if (config.showSuccessToast) {
      final message =
          config.successMessage ??
          DioExceptions.extractMessage(response.data) ??
          'Success';
      if (message.trim().isNotEmpty) {
        AppToast.showToast(message, isError: false);
      }
    }
    handler.next(response);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final config = ApiClient.resolveConfig(err.requestOptions);
    final exception = DioExceptions.fromDioError(err);

    if (config.showErrorToast) {
      AppToast.showToast(exception.message, isError: true);
    }

    if (exception.isUnauthorized) {
      AuthService.removeToken();
      // TODO: handle logout / navigation if required.
    }

    handler.next(err);
  }
}
