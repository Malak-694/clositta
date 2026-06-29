import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/chat/logic/conversations_cubit/conversations_cubit.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:chicora/features/notifications/data/models/unread_count_response.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/buyer_product_screen_body.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerProductsScreen extends StatefulWidget {
  const CustomerProductsScreen({super.key});

  @override
  State<CustomerProductsScreen> createState() => _CustomerProductsScreenState();
}

class _CustomerProductsScreenState extends State<CustomerProductsScreen> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    context.read<ConversationsCubit>().loadUnreadCount();
  }

  Future<void> _loadUserId() async {
    final prefs = getIt<SharedPrefHelper>();
    final id = await prefs.getSecureData(SharedPrefKey.id);
    if (!mounted) return;
    setState(() => _currentUserId = id);
  }

  @override
  Widget build(BuildContext context) {
    // ── Read all counts here once, no nesting ──────────────
    final cartCount   = cartTotalItemQuantity(context.watch<CartCubit>().state);
    final chatCount   = context.watch<ConversationsCubit>().unreadCount;
    final notifCount = context.read<NotificationCubit>().unreadCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Welcome to Clositta',
        showCartIcon: true,
        cartItemCount: cartCount,
        onCartTap: () => Navigator.pushNamed(context, RouteNames.customer_cart_screen),
        showNotificationIcon: true,
        unreadNotificationCount: notifCount,
        onNotificationTap: () => Navigator.pushNamed(context, RouteNames.notification_screen),
        showChatIcon: true,
        unreadChatCount: chatCount,
        onChatTap: () => Navigator.pushNamed(
          context,
          RouteNames.conversations_screen,
          arguments: {'currentUserId': _currentUserId ?? ''},
        ),
      ),
      body: const BuyerProductScreenBody(),
      bottomNavigationBar: FloatingNavBar(userRole: 'customer', selectedIndex: 0),
    );
  }
}