import 'package:chicora/core/router/route_names.dart';
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
import '../../data/repo/closet_repo.dart';
import '../../logic/cubit/closet_cubit.dart';
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
  }
  Future<void> _loadUserId() async {
    final prefs = getIt<SharedPrefHelper>();
    final id = await prefs.getSecureData(SharedPrefKey.id);
    if (!mounted) return;
    setState(() => _currentUserId = id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<CartCubit, CartState<dynamic>>(
          builder: (context, cartState) {
            return BlocBuilder<ConversationsCubit,
                ConversationsState<List<ConversationModel>>>(
              builder: (context, convState) {
                final unreadCount = context.read<ConversationsCubit>().unreadCount;

                return CustomAppBar(
                  title: "Your clothes",
                  showCartIcon: true,
                  cartItemCount: cartTotalItemQuantity(cartState),
                  onCartTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.customer_cart_screen,
                  ),
                  showChatIcon: true,
                  unreadChatCount: unreadCount,
                  onChatTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.conversations_screen,
                    arguments: {
                      'currentUserId': _currentUserId ?? '',
                    },
                  ),
                );
              },
            );
          },
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
