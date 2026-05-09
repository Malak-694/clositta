import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/theme/app_theme.dart';
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

/// Matches Paymob HTML callback: `app://clositta.com/orders/?...`
bool _isOrdersReturnDeepLink(Uri uri) {
  if (uri.scheme != 'app' || uri.host != 'clositta.com') return false;
  final p = uri.path;
  return p == '/orders/' || p == '/orders';
}

class ChicoraApp extends StatefulWidget {
  final String initialRoute;
  const ChicoraApp({super.key, required this.initialRoute});

  @override
  State<ChicoraApp> createState() => _ChicoraAppState();
}

class _ChicoraAppState extends State<ChicoraApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _listenForOrderReturnDeepLinks();
  }

  Future<void> _listenForOrderReturnDeepLinks() async {
    Uri? handledForDedup;

    void handle(Uri uri) {
      if (!_isOrdersReturnDeepLink(uri)) return;
      if (handledForDedup == uri) return;
      handledForDedup = uri;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final nav = appNavigatorKey.currentState;
        if (nav == null || !nav.mounted) return;
        nav.pushNamed(RouteNames.order_view_screen);
      });
    }

    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) handle(initial);
    } catch (_) {
      // ignore: plugin may fail on unsupported platforms during tests
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(handle);
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

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
          initialRoute: widget.initialRoute,
          onGenerateRoute: AppRouter.generateRoute,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
