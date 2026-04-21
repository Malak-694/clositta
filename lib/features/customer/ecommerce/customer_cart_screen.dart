import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/cart_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/route_names.dart';

class CustomerCartScreen extends StatelessWidget {
  const CustomerCartScreen({super.key});

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

      body: BlocProvider(
        create: (_) => getIt<CartCubit>(),
        child: CartScreenBody(),
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
