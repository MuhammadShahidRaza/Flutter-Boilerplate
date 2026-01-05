class LoaderKeyGenerator {
  const LoaderKeyGenerator._();

  static String generate({String scope = 'global', required String title}) {
    final normalizedScope = _normalize(scope);
    final normalizedTitle = _normalize(title);
    return 'loader.$normalizedScope.$normalizedTitle.button';
  }

  static String _normalize(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]+'), '');
  }
}
