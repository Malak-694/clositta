import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/auth/ui/screens/password_recovery_screen.dart';
import 'package:chicora/features/auth/ui/screens/recovery_code_screen.dart';
import 'package:chicora/features/auth/ui/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../features/auth/ui/screens/login_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RouteNames.login:
        return MaterialPageRoute(builder: (_)=> LoginScreen());
      case RouteNames.passord_recovery:
        return MaterialPageRoute(builder: (_)=> PasswordRecoveryScreen());
      case RouteNames.recovery_code:
        return MaterialPageRoute(builder: (_)=> RecoveryCodeScreen());
      case RouteNames.reset_password:
        return MaterialPageRoute(builder: (_)=> ResetPasswordScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined for this path')),
          ),
        );
    }
  }
}