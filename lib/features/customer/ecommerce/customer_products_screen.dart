import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/router/route_names.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../ecommerce_multi/logic/view_product_logic/view_products_cubit.dart';
import '../../ecommerce_multi/ui/screens/buyer_product_screen_body.dart';

class CustomerProductsScreen extends StatelessWidget {
  const CustomerProductsScreen({super.key});

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
          BlocProvider(create: (_) => getIt<ViewProductsCubit>()),
          BlocProvider(create: (_) => getIt<CartCubit>()),
        ],
        child: const BuyerProductScreenBody(),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'customer',
        selectedIndex: 0,
        focused: AppColors.primery,
        notSelected: AppColors.darkprimery,
      ),
    );
  }
}
