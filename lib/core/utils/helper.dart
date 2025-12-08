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

  static String capitalize(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final v = value.trim();
    return v[0].toUpperCase() + v.substring(1).toLowerCase();
  }

  static String getfullName(user) {
    final f = Utils.capitalize(user?.firstName);
    final l = Utils.capitalize(user?.lastName);
    return [f, l].where((e) => e.isNotEmpty).join(' ');
  }
}
