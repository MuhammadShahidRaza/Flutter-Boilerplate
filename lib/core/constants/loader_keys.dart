class LoaderKeys {
  const LoaderKeys._();

  /// Build a scoped button loader key: e.g. `LoaderKeys.button(scope: 'auth')`
  /// -> `loader.auth.primary.button`
  static String button({required String scope, String variant = 'primary'}) {
    return 'loader.$scope.$variant.button';
  }

  /// Build a custom loader key with a single segment: `loader.<name>`.
  static String custom(String name) => 'loader.$name';
}
