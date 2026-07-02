import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/models/conversation_model.dart';
import '../../logic/conversations_cubit/conversations_cubit.dart';
import '../../logic/conversations_cubit/conversations_state.dart';
import '../widgets/conversation_tile.dart';

class ConversationsScreen extends StatefulWidget {
  final String currentUserId;

  const ConversationsScreen({super.key, required this.currentUserId});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
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
    final cartCount = cartTotalItemQuantity(context.watch<CartCubit>().state);
    final chatCount = context.watch<ConversationsCubit>().unreadCount;
    final notifCount = context.read<NotificationCubit>().unreadCount;

    return BlocProvider(
      create: (_) => getIt<ConversationsCubit>()..loadConversations(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'Messages',
          showCartIcon: true,
          leading: true,
          cartItemCount: cartCount,
          onCartTap: () =>
              Navigator.pushNamed(context, RouteNames.customer_cart_screen),
          showNotificationIcon: true,
          unreadNotificationCount: notifCount,
          onNotificationTap: () =>
              Navigator.pushNamed(context, RouteNames.notification_screen),
          showChatIcon: true,
          unreadChatCount: chatCount,
          onChatTap: () => Navigator.pushNamed(
            context,
            RouteNames.conversations_screen,
            arguments: {'currentUserId': _currentUserId ?? ''},
          ),
        ),
        body:
            BlocBuilder<
              ConversationsCubit,
              ConversationsState<List<ConversationModel>>
            >(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox(),

                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primery),
                  ),

                  fail: (msg) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.light,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          msg,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.light),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primery,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => context
                              .read<ConversationsCubit>()
                              .loadConversations(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),

                  success: (conversations) {
                    if (conversations.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No conversations yet',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primery,
                      onRefresh: () => context
                          .read<ConversationsCubit>()
                          .loadConversations(),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: conversations.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1, indent: 72),
                        itemBuilder: (context, index) {
                          final conv = conversations[index];
                          return ConversationTile(
                            conversation: conv,
                            currentUserId: widget.currentUserId,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
        bottomNavigationBar: FloatingNavBar(
          userRole: 'customer',
          selectedIndex: 0,
        ),
      ),
    );
  }
}
