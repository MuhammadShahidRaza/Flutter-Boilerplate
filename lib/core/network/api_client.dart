import 'package:dio/dio.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/services/auth.dart';
import 'package:sanam_laundry/providers/index.dart';

class ApiClient {
  ApiClient._({String? customBaseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: customBaseUrl ?? Environment.baseUrl,
        // Tighter defaults to fail fast on flaky connections
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LanguageInterceptor(),
      _LoaderInterceptor(),
      // Retry before error handling so users don't see toasts for transient issues
      RetryInterceptor(dio: _dio),
      _SuccessInterceptor(),
      _ErrorInterceptor(),
      if (Environment.enableLogs)
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
        ),
    ]);
  }

  late final Dio _dio;

  static final ApiClient _instance = ApiClient._();
  static Dio get instance => _instance._dio;

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
}

class _LanguageInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final language = await AuthService.loadLanguage();
    options.headers['Accept-Language'] = language ?? Language.en.name;
    handler.next(options);
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
  static const _scopedLoaderKey = '_sanam_scoped_loader_key';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final config = ApiClient.resolveConfig(options);

    // 🔹 Global loader (full-screen overlay)
    if (config.showLoader) {
      LoaderService.instance.start('loader.global'); // ✅ use start()
      options.extra[_loaderKey] = true;
    }

    // 🔹 Scoped button loader (per-button)
    if (config.showButtonLoader) {
      final loaderKey = config.loaderKey;

      if (loaderKey != null && loaderKey.isNotEmpty) {
        LoaderService.instance.start(loaderKey); // ✅ use start()
        options.extra[_scopedLoaderKey] = loaderKey;
      }
      // ✅ Fallback — if no key & not using global loader, use global as fallback
      // else if (!config.showLoader && options.extra[_loaderKey] != true) {
      //   LoaderService.instance.start('loader.global');
      //   options.extra[_loaderKey] = true;
      // }
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
    if (options.extra[_loaderKey] == true) {
      LoaderService.instance.stop('loader.global'); // ✅ stop global
      options.extra.remove(_loaderKey);
    }

    final scopedKey = options.extra[_scopedLoaderKey];
    if (scopedKey is String && scopedKey.isNotEmpty) {
      LoaderService.instance.stop(scopedKey); // ✅ stop scoped
      options.extra.remove(_scopedLoaderKey);
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

class AuthStateService {
  static bool isLoggedIn = false;
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final config = ApiClient.resolveConfig(err.requestOptions);
    final exception = DioExceptions.fromDioError(err);

    if (config.showErrorToast) {
      if (exception.message.isNotEmpty) {
        if (exception.message == "Unauthenticated." ||
            exception.isUnauthorized && AuthStateService.isLoggedIn) {
          AppToast.showToast(
            "Session expired. Please login again.",
            isError: true,
          );
        } else {
          if (exception.message ==
              "Something went wrong. Please try again later.") {
          } else {
            AppToast.showToast(exception.message, isError: true);
          }
        }
      }
    }

    if (exception.isUnauthorized && AuthStateService.isLoggedIn) {
      AuthService.removeToken();
      final router = GoRouterSetup.router;
      router.go(AppRoutes.getStarted);
    }

    handler.next(err);
  }
}
