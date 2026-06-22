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

class TailorProductsScreen extends StatelessWidget {
  const TailorProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = getIt<SharedPrefHelper>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<CartCubit, CartState<dynamic>>(
          builder: (context, cartState) {
            return BlocBuilder<ConversationsCubit,
                ConversationsState<List<ConversationModel>>>(
              builder: (context, convState) {
                final unreadCount =
                    context.read<ConversationsCubit>().unreadCount;
                return CustomAppBar(
                  title: "Clositta Store",
                  showCartIcon: true,
                  cartItemCount: cartTotalItemQuantity(cartState),
                  onCartTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.tailor_cart_screen,
                  ),
                  showChatIcon: true,
                  unreadChatCount: unreadCount,
                  onChatTap: () async {
                    final userId = await prefs.getSecureData('id') ?? '';
                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        RouteNames.conversations_screen,
                        arguments: {'currentUserId': userId},
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),

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
