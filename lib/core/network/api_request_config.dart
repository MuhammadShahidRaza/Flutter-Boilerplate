class ApiRequestConfig {
  const ApiRequestConfig({
    this.requiresAuth = true,
    this.showLoader = true,
    this.showErrorToast = true,
    this.showSuccessToast = false,
    this.successMessage,
  });

  final bool requiresAuth;
  final bool showLoader;
  final bool showErrorToast;
  final bool showSuccessToast;
  final String? successMessage;

  static const String extraKey = '_apiRequestConfig';

  ApiRequestConfig copyWith({
    bool? requiresAuth,
    bool? showLoader,
    bool? showErrorToast,
    bool? showSuccessToast,
    String? successMessage,
  }) {
    return ApiRequestConfig(
      requiresAuth: requiresAuth ?? this.requiresAuth,
      showLoader: showLoader ?? this.showLoader,
      showErrorToast: showErrorToast ?? this.showErrorToast,
      showSuccessToast: showSuccessToast ?? this.showSuccessToast,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
