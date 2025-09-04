import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();

Future<void> addDataToStorage(String key, String value) async {
  return await storage.write(key: key, value: value);
}

Future<String?> getDataFromStorage(String key) async {
  return await storage.read(key: key);
}

Future<void> deleteDataFromStorage(String key) async {
  return await storage.delete(key: key);
}

Future<void> clearAllDataFromStorage() async {
  return await storage.deleteAll();
}
