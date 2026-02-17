import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/router/app_router.dart';
import 'core/router/route_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();

  //   await initializeDateFormatting('ar', null);

  final prefs = getIt<SharedPrefHelper>();
  final token = await prefs.getSecureData(SharedPrefKey.token);
  final role = await prefs.getSecureData(SharedPrefKey.role);

  String initialRoute = (token != null && token.isNotEmpty)
      ? (role == "tailor" ? RouteNames.view_bidding_tailor : RouteNames.posts)
      : RouteNames.login;
  initialRoute = RouteNames.customer_products_screen;


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
          initialRoute: initialRoute,
          onGenerateRoute: AppRouter.generateRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
