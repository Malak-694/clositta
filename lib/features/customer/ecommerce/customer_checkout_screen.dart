import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_cubit.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/checkout_screen.dart'
    show CheckoutScreenBody;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerCheckoutScreen extends StatelessWidget {
  const CustomerCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Welcome to Clositta",
        showCartIcon: true,
        onCartTap: () =>
            Navigator.pushNamed(context, RouteNames.customer_cart_screen),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<CartCubit>()),
          BlocProvider(create: (_) => getIt<OrderCubit>()),
        ],
        child: const CheckoutScreenBody(),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'customer',
        selectedIndex: 0,

      ),
    );
  }
}
