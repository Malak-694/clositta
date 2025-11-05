import 'package:chicora/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../features/auth/ui/screens/login_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RouteNames.login:
        return MaterialPageRoute(builder: (_)=> LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined for this path')),
          ),
        );
    }
  }
}