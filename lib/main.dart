import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/router/app_router.dart';
import 'core/router/route_names.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

String getInitialRoute(String? token, String? role) {
  if (token == null || token.isEmpty) {
    return RouteNames.login;
  }

  switch (role) {
    case 'customer':
      return RouteNames.posts_customer;

    case 'tailor':
      return RouteNames.login;

    case 'clothes_seller':
    case 'material_seller':
      return RouteNames.login;

    default:
      return RouteNames.login;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();

  //   await initializeDateFormatting('ar', null);

  final prefs = getIt<SharedPrefHelper>();
  final token = await prefs.getSecureData(SharedPrefKey.token);
  final role = await prefs.getSecureData(SharedPrefKey.role);
  final initialRoute = getInitialRoute(token, role);

  print(role);
  print(initialRoute);
  runApp(ChicoraApp(initialRoute: initialRoute));
}

class ChicoraApp extends StatelessWidget {
  final String initialRoute;
  const ChicoraApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917), // iPhone X size (adjust as needed)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Chicora',
          navigatorKey: appNavigatorKey,
          initialRoute: initialRoute,
          onGenerateRoute: AppRouter.generateRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
