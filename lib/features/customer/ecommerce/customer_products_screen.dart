import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/chat/logic/conversations_cubit/conversations_cubit.dart';
import 'package:chicora/features/chat/logic/conversations_cubit/conversations_state.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/buyer_product_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat/data/models/conversation_model.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<CartCubit, CartState<dynamic>>(
          builder: (context, cartState) {
            return BlocBuilder<ConversationsCubit,
                ConversationsState<List<ConversationModel>>>(
              builder: (context, convState) {
                final unreadCount = context.read<ConversationsCubit>().unreadCount;

                return CustomAppBar(
                  title: "Welcome to Clositta",
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
      body: const BuyerProductScreenBody(),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'customer',
        selectedIndex: 0,
      ),
    );
  }
}