import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import '../../../../chat/data/models/conversation_model.dart';
import '../../../../chat/logic/conversations_cubit/conversations_cubit.dart';
import '../../../../chat/logic/conversations_cubit/conversations_state.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_state.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import '../../../../notifications/data/models/unread_count_response.dart';
import '../../../../notifications/logic/cubit/notification_cubit.dart';
import '../widgets/closet_items_body.dart';

class ClosetItemsScreen extends StatefulWidget {
  const ClosetItemsScreen({super.key});

  @override
  State<ClosetItemsScreen> createState() => _ClosetItemsScreenState();
}

class _ClosetItemsScreenState extends State<ClosetItemsScreen> {

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
    final cartCount   = cartTotalItemQuantity(context.watch<CartCubit>().state);
    final chatCount   = context.watch<ConversationsCubit>().unreadCount;
    final notifCount  = context.watch<NotificationCubit>().state.maybeWhen(
      success: (data) => data is UnreadCountResponse ? data.unreadCount : 0,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Your clothes',
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
      body: ClosetItemsScreenBody(),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'customer',
        selectedIndex: 2,
      ),
    );
  }
}
