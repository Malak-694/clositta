import 'dart:ui';
import '../di/dependency_injection.dart';
import '../helper/shared_pref_helper.dart';
import '../helper/shared_key.dart';

class AppColors {
  static const background = Color.fromARGB(255, 255, 255, 255);
  static const dark = Color.fromARGB(255, 3, 2, 8);
  static const light = Color(0xFF9A9A9A);
  static const lightprimery = Color(0xFFEDEDFF);
  static const primery = Color(0xFF5E50B6);
  static const darkprimery = Color.fromRGBO(39, 32, 83, 1);
  static const secondary = Color(0xFFFFC333);
  static const darksecondary = Color.fromARGB(255, 175, 133, 34);

  static const lightsecondary = Color.fromARGB(255, 255, 233, 183);
  static const ternary = Color(0xFFFF6464);

  static const darkternary = Color.fromARGB(255, 163, 46, 46);
  static const lightternary = Color(0xFFF18C88);

  /// Returns a primary color based on a user role string.
  ///
  /// Known roles: 'customer', 'tailor', 'admin', 'clothes_seller', 'material_seller'.
  /// If [role] is null or unrecognized, returns the default `primery` color.
  static Color primaryForRole(String? role) {
    if (role == null) return primery;
    switch (role.toLowerCase()) {
      case 'customer':
        return primery; // purple (default)
      case 'tailor':
        return secondary; // blue
      case 'admin':
        return Color(0xFFDD2C00); // red/orange
      case 'clothes_seller':
        return ternary; // green
      case 'material_seller':
        return ternary; // amber
      default:
        return primery;
    }
  }

  static Color darkForRole(String? role) {
    if (role == null) return primery;
    switch (role.toLowerCase()) {
      case 'customer':
        return darkprimery; // purple (default)
      case 'tailor':
        return darksecondary; // blue
      case 'admin':
        return darkternary; // red/orange
      case 'clothes_seller':
        return darkternary; // green
      case 'material_seller':
        return darkternary; // amber
      default:
        return primery;
    }
  }

  /// Asynchronously reads the stored role (if any) and returns the mapped primary color.
  /// Uses the `SharedPrefHelper` from the service locator.
  static Future<Color> primaryForCurrentUser() async {
    try {
      final prefs = getIt<SharedPrefHelper>();
      final role = await prefs.getSecureData(SharedPrefKey.role);
      return primaryForRole(role);
    } catch (_) {
      return primery;
    }
  }

  static Future<Color> darkForCurrentUser() async {
    try {
      final prefs = getIt<SharedPrefHelper>();
      final role = await prefs.getSecureData(SharedPrefKey.role);
      return darkForRole(role);
    } catch (_) {
      return darkprimery;
    }
  }
}
