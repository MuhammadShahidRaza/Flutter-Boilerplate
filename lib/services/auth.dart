import 'package:sanam_laundry/constants/variables.dart';
import 'package:sanam_laundry/utils/storage.dart';

class AuthService {
  static String? _token;

  static Future<void> loadToken() async {
    final token = await Storage.getDataFromStorage(Variables.userToken);
    _token = token;
  }

  static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  static Future<void> saveToken(String token) async {
    _token = token;
    await Storage.addDataToStorage(Variables.userToken, token);
  }

  static Future<void> removeToken() async {
    _token = null;
    await Storage.deleteDataFromStorage(Variables.userToken);
  }
}
