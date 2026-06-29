import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/main.dart';
import 'package:flutter/foundation.dart';

class DioFactory {
  DioFactory._();
  static Dio? dio;
  static bool _isHandlingExpiredToken = false;
  static Dio getDio() {
    Duration timeOut = Duration(minutes: 2);
    if (dio == null) {
      dio = Dio();
      dio!..options.connectTimeout = timeOut;
      dio!..options.receiveTimeout = timeOut;
      addDioHeader();
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioHeader() async {
    dio!..options.headers = {
      'Accept': 'application/json',
      'Content-Type': null,
    };
  }

  static void addDioInterceptor() {
    if (kDebugMode) {
      dio?.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
    }
    dio?.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_hasExpiredTokenMessage(error) && !_isHandlingExpiredToken) {
            _isHandlingExpiredToken = true;
            await _handleExpiredToken();
            _isHandlingExpiredToken = false;
          }
          handler.next(error);
        },
      ),
    );
  }

  static bool _hasExpiredTokenMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      return message == 'Invalid or expired token';
    }
    return false;
  }

  static Future<void> _handleExpiredToken() async {
    final sharedPrefHelper = getIt<SharedPrefHelper>();
    await sharedPrefHelper.removeSecureData(SharedPrefKey.token);
    await sharedPrefHelper.removeSecureData(SharedPrefKey.role);
    await sharedPrefHelper.removeSecureData(SharedPrefKey.id);

    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;

    navigator.pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
  }
}