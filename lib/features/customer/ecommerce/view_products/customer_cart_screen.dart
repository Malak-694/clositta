import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/cart_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/di/dependency_injection.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/custom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/route_names.dart';

class CustomerCartScreen extends StatelessWidget {
  const CustomerCartScreen({super.key});

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
                  RouteNames.customer_cart_screen,
                ),
              );
            },
          ),
        ),
        body: const CartScreenBody(),
        bottomNavigationBar: FloatingNavBar(
          userRole: 'customer',
          selectedIndex: 0,
          focused: AppColors.primery,
          notSelected: AppColors.darkprimery,
        ),
      ),
    );
  }
}
