class ApiRequestConfig {
  static const String extraKey = '_apiRequestConfig';

  final bool requiresAuth;
  final bool showLoader;
  final bool showErrorToast;
  final bool showButtonLoader;
  final bool showSuccessToast;
  final String? successMessage;
  final String? loaderKey;

  const ApiRequestConfig({
    this.requiresAuth = true,
    this.showLoader = false,
    this.showErrorToast = true,
    this.showSuccessToast = false,
    this.showButtonLoader = true,
    this.successMessage,
    this.loaderKey,
  });

  ApiRequestConfig copyWith({
    bool? requiresAuth,
    bool? showLoader,
    bool? showErrorToast,
    bool? showSuccessToast,
    bool? showButtonLoader,
    String? successMessage,
    Object? loaderKey = _sentinel,
  }) {
    return ApiRequestConfig(
      requiresAuth: requiresAuth ?? this.requiresAuth,
      showLoader: showLoader ?? this.showLoader,
      showErrorToast: showErrorToast ?? this.showErrorToast,
      showSuccessToast: showSuccessToast ?? this.showSuccessToast,
      showButtonLoader: showButtonLoader ?? this.showButtonLoader,
      successMessage: successMessage ?? this.successMessage,
      loaderKey: identical(loaderKey, _sentinel)
          ? this.loaderKey
          : loaderKey as String?,
    );
  }
}

const Object _sentinel = Object();
