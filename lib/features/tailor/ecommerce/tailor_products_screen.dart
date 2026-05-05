import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/router/route_names.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../ecommerce_multi/logic/cart_cubit/cart_state.dart';
import '../../ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import '../../ecommerce_multi/logic/view_product_logic/view_products_cubit.dart';
import '../../ecommerce_multi/ui/screens/buyer_product_screen_body.dart';

class TailorProductsScreen extends StatelessWidget {
  const TailorProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cart = getIt<CartCubit>();
        cart.getCart();
        return cart;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<CartCubit, CartState<dynamic>>(
            builder: (context, state) {
              return CustomAppBar(
                title: "Welcome to Clositta",
                showCartIcon: true,
                cartItemCount: cartTotalItemQuantity(state),
                onCartTap: () => Navigator.pushNamed(
                  context,
                  RouteNames.tailor_cart_screen,
                ),
              );
            },
          ),
        ),
        body: BlocProvider(
          create: (_) => getIt<ViewProductsCubit>(),
          child: const BuyerProductScreenBody(),
        ),
        bottomNavigationBar: FloatingNavBar(
          userRole: 'tailor',
          selectedIndex: 3,
          focused: AppColors.secondary,
          notSelected: AppColors.darksecondary,
        ),
      ),
    );
  }
}
