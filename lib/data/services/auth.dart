import 'package:sanam_laundry/core/constants/variables.dart';
import 'package:sanam_laundry/core/utils/storage.dart';

class AuthService {
  static Future<String?> loadToken() async {
    return await Storage.getDataFromStorage(Variables.userToken);
  }

  static Future<String?> hasVisitedApp() async {
    return await Storage.getDataFromStorage(Variables.hasVisitedApp);
  }

  static Future<void> saveToken(String token) async {
    await Storage.addDataToStorage(Variables.userToken, token);
  }

  static Future<void> removeToken() async {
    await Storage.deleteDataFromStorage(Variables.userToken);
  }
}
