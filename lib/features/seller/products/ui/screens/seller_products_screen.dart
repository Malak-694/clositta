import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import '../../../../notifications/data/models/unread_count_response.dart';
import '../../../../notifications/logic/cubit/notification_cubit.dart';
import '../widgets/seller_product_screen_body.dart';

class SellerProductsScreen extends StatelessWidget {
  final prefs = getIt<SharedPrefHelper>();

  SellerProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {

    final notifCount  = context.watch<NotificationCubit>().state.maybeWhen(
      success: (data) => data is UnreadCountResponse ? data.unreadCount : 0,
      orElse: () => 0,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'My Products',
        showCartIcon: false,
        onCartTap: () => Navigator.pushNamed(context, RouteNames.customer_cart_screen),
        showNotificationIcon: true,
        unreadNotificationCount: notifCount,
        onNotificationTap: () => Navigator.pushNamed(context, RouteNames.notification_screen),

      ),
      body: SellerProductScreenBody(),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'seller',
        selectedIndex: 0,
      ),
    );
  }
}
