import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/notification_helper.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/router/app_router.dart';
import 'core/router/route_names.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/chat/logic/conversations_cubit/conversations_cubit.dart';
import 'features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'features/notifications/logic/cubit/notification_cubit.dart';
import 'firebase_options.dart';

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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationHelper.initialize();
  final prefs = getIt<SharedPrefHelper>();
  final token      = await prefs.getSecureData(SharedPrefKey.token);
  final role       = await prefs.getSecureData(SharedPrefKey.role);
  final savedDark  = prefs.getData(SharedPrefKey.isDarkMode) as bool? ?? false;

  if (token != null && token.isNotEmpty) {
    NotificationHelper.sendTokenToBackend();
  }

  final initialRoute = getInitialRoute(token, role);
  final bool needsCartAndChat = role == 'customer' || role == 'tailor';

  runApp(
    needsCartAndChat
        ? MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (_) => getIt<CartCubit>()..getCart(),
        ),
        BlocProvider<ConversationsCubit>(
          create: (_) => getIt<ConversationsCubit>()..loadUnreadCount(),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) => getIt<NotificationCubit>()..getUnreadCount(),
        ),
      ],
      child: ChicoraApp(initialRoute: initialRoute, savedDark: savedDark),
    )
        : ChicoraApp(initialRoute: initialRoute, savedDark: savedDark),
  );
}

bool _isOrdersReturnDeepLink(Uri uri) {
  if (uri.scheme != 'app' || uri.host != 'clositta.com') return false;
  final p = uri.path;
  return p == '/orders/' || p == '/orders';
}

class ChicoraApp extends StatefulWidget {
  final String initialRoute;
  final bool savedDark;
  const ChicoraApp({super.key, required this.initialRoute, this.savedDark = false});

  static _ChicoraAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_ChicoraAppState>()!;

  @override
  State<ChicoraApp> createState() => _ChicoraAppState();
}

class _ChicoraAppState extends State<ChicoraApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.savedDark ? ThemeMode.dark : ThemeMode.light;
    _listenForOrderReturnDeepLinks();
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setState(() => _themeMode = newMode);
    // Persist so the choice survives app restarts
    await getIt<SharedPrefHelper>().setData(
      SharedPrefKey.isDarkMode,
      newMode == ThemeMode.dark,
    );
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

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
    } catch (_) {}

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
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
        );
      },
    );
  }
}
