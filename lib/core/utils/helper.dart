class Utils {
  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static List safeList(dynamic value) {
    return value is List ? value : [];
  }

  static Map safeMap(dynamic value) {
    return value is Map ? value : {};
  }
}
