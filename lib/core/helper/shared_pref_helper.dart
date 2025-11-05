import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Call this once in setupGetIt()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// --------------------
  /// NORMAL STORAGE
  /// --------------------

  dynamic getData(String key) {
    return _prefs?.get(key);
  }

  Future<void> setData(String key, dynamic value) async {
    if (_prefs == null) throw Exception("SharedPrefHelper not initialized");

    switch (value.runtimeType) {
      case const (String):
        await _prefs!.setString(key, value);
        break;
      case const (int):
        await _prefs!.setInt(key, value);
        break;
      case const (double):
        await _prefs!.setDouble(key, value);
        break;
      case const (bool):
        await _prefs!.setBool(key, value);
        break;
      case const (List<String>):
        await _prefs!.setStringList(key, value);
        break;
      default:
        throw Exception("Unsupported type");
    }
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  /// --------------------
  /// SECURE STORAGE (Encrypted)
  /// --------------------

  Future<void> setSecureData(String key, dynamic value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<String?> getSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> removeSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearAllSecure() async {
    await _secureStorage.deleteAll();
  }
}