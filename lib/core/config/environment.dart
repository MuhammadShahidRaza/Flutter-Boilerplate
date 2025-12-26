import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return ".env.production";
    }
    return ".env.development";
  }

  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static bool get enableLogs => kDebugMode ? true : false;
  static String get mapKey => dotenv.env['MAP_API_KEY'] ?? '';
  static String get myFatoorahTestMode =>
      dotenv.env['MY_FATOORAH_TEST_MODE'] ?? 'true';
  static String get myFatoorahApiKey => dotenv.env['MY_FATOORAH_API_KEY'] ?? '';
}
