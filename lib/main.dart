import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:chicora/core/constants/colors.dart';
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
      return RouteNames.view_bidding_tailor;
    case 'clothes_seller':
    case 'material_seller':
      return RouteNames.seller_products_screen;
    default:
      return RouteNames.login;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();

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

  // ← Any widget calls ChicoraApp.of(context).toggleTheme()
  static _ChicoraAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_ChicoraAppState>()!;

  @override
  State<ChicoraApp> createState() => _ChicoraAppState();
}

class _ChicoraAppState extends State<ChicoraApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

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
      designSize: const Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Chicora',
          navigatorKey: appNavigatorKey,
          initialRoute: widget.initialRoute,
          onGenerateRoute: AppRouter.generateRoute,
          debugShowCheckedModeBanner: false,
          themeMode: _themeMode,

          // ── Light theme (your existing)
          theme: AppTheme.lightTheme,

          // ── Dark theme using your AppColors
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1A1A2E),
            primaryColor: AppColors.primery,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primery,
              secondary: AppColors.darksecondary,
              surface: Color(0xFF1A1A2E),
              error: AppColors.ternary,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1A1A2E),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            cardColor: const Color(0xFF252540),
            iconTheme: const IconThemeData(color: Colors.white),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(color: Colors.white60),
            ),
            listTileTheme: const ListTileThemeData(
              tileColor: Color(0xFF252540),
              textColor: Colors.white,
              iconColor: Colors.white70,
            ),
            dividerColor: Colors.white12,
            dialogBackgroundColor: const Color(0xFF252540),
          ),
        );
      },
    );
  }
}