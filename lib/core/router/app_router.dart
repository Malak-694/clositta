import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/auth/ui/screens/password_recovery_screen.dart';
import 'package:chicora/features/auth/ui/screens/recovery_code_screen.dart';
import 'package:chicora/features/auth/ui/screens/reset_password_screen.dart';
import 'package:chicora/features/auth/ui/screens/log_in_screen.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/biding/ui/Screens/detailes_screen.dart';
import 'package:chicora/features/customer/biding/ui/Screens/form_screen.dart';
import 'package:chicora/features/customer/biding/ui/Screens/post_screen.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/ui/Screens/detailes_screen_tailor.dart';
import 'package:chicora/features/tailor/bidding_tailor/ui/Screens/join_bidding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/ui/screens/sign_up_screen.dart';
import '../../features/tailor/bidding_tailor/ui/Screens/posts_tailor_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: LoginScreen(),
          ),
        );
      case RouteNames.sing_up:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: SignUpScreen(),
          ),
        );
      case RouteNames.passord_recovery:
        return MaterialPageRoute(builder: (_) => PasswordRecoveryScreen());
      case RouteNames.recovery_code:
        return MaterialPageRoute(builder: (_) => RecoveryCodeScreen());
      case RouteNames.reset_password:
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case RouteNames.posts:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<CustomerBiddingCubit>(),
            child: PostScreen(),
          ),
        );
      case RouteNames.upload_post:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<CustomerBiddingCubit>(),
              child: FormScreen(),
            )
        );
      case RouteNames.view_bidding_tailor:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<BiddingTailorCubit>(),
            child: PostScreenTailor(),
          ),
        );


      case RouteNames.post_details_customer: // ✅ Define this constant
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final bidId = args['bidId'] as String? ?? '';
        final urlImage = args['urlImage'] as String? ?? '';
        final description = args['description'] as String? ?? '';

        return MaterialPageRoute(
          builder: (_) => BlocProvider<CustomerBiddingCubit>(
            create: (context) => getIt<CustomerBiddingCubit>(),
            child: DetailesScreen(
              bidId: bidId,
              urlImage: urlImage,
              description: description,
            ),
          )
        );
      case RouteNames.view_offers_tailor:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final urlImage = args['urlImage'] as String? ?? '';
        final description = args['description'] as String? ?? '';
         final price = args['price'] as String? ?? '';
          final period = args['period'] as String? ?? '';
        final postId = args['postId'] as String? ?? ''; // optional

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<BiddingTailorCubit>(),
            child: DetailesScreenTailor(
              urlImage: urlImage,
              price: price,
              period: period,
              describtion: description,
              postId: postId,
            ),
          ),
        );
      case RouteNames.join_bidding:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final urlImage = args['urlImage'] as String? ?? '';
        final price = args['price'] as String? ?? '';
        final period = args['period'] as String? ?? '';
        final title = args['title'] as String? ?? '';
        final postId = args['postId'] as String? ?? '';

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<BiddingTailorCubit>(),
            child: JoinBiddingScreen(
              imageUrl: urlImage,
              price: price,
              period: period,
              title: title,
              postId: postId,
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined for this path')),
          ),
        );
    }
  }
}
