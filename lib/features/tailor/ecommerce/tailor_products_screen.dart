import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/router/route_names.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../chat/data/models/conversation_model.dart';
import '../../chat/logic/conversations_cubit/conversations_cubit.dart';
import '../../chat/logic/conversations_cubit/conversations_state.dart';
import '../../ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../ecommerce_multi/logic/cart_cubit/cart_state.dart';
import '../../ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import '../../ecommerce_multi/logic/view_product_logic/view_products_cubit.dart';
import '../../ecommerce_multi/ui/screens/buyer_product_screen_body.dart';
import '../../notifications/data/models/unread_count_response.dart';
import '../../notifications/logic/cubit/notification_cubit.dart';

class TailorProductsScreen extends StatelessWidget {
  const TailorProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = getIt<SharedPrefHelper>();
    final cartCount   = cartTotalItemQuantity(context.watch<CartCubit>().state);
    final chatCount   = context.watch<ConversationsCubit>().unreadCount;
    final notifCount  = context.watch<NotificationCubit>().state.maybeWhen(
      success: (data) => data is UnreadCountResponse ? data.unreadCount : 0,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
          title: 'Clositta Store',
          showCartIcon: true,
          cartItemCount: cartCount,
          onCartTap: () => Navigator.pushNamed(context, RouteNames.customer_cart_screen),
          showNotificationIcon: true,
          unreadNotificationCount: notifCount,
          onNotificationTap: () => Navigator.pushNamed(context, RouteNames.notification_screen),
          showChatIcon: true,
          unreadChatCount: chatCount,
          onChatTap: () async {
            final userId = await prefs.getSecureData('id') ?? '';
            Navigator.pushNamed(
              context,
              RouteNames.conversations_screen,
              arguments: {'currentUserId': userId ?? ''},
            );
          }),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<ViewProductsCubit>()),
          BlocProvider(create: (_) => getIt<CartCubit>()),
        ],
        child: const BuyerProductScreenBody(),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'tailor',
        selectedIndex: 3,

      ),
    );
  }
}
