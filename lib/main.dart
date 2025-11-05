import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/router/app_router.dart';
import 'core/router/route_names.dart';

void main()async {
  // setupGetIt();
  //   await initializeDateFormatting('ar', null);

  runApp(const ChicoraApp());
}

class ChicoraApp extends StatelessWidget {
  const ChicoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917), // iPhone X size (adjust as needed)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Chicora',
          initialRoute: RouteNames.reset_password,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}