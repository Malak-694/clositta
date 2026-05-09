import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/cart_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/style.dart';
import '../../../core/router/route_names.dart';

class TailorCartScreen extends StatelessWidget {
  const TailorCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Welcome to Clositta",
        style: AppStyle.medSecondary,
        leadingIcon: Icons.arrow_back,
        leading: true,
        showCartIcon: true,
        onCartTap: () =>
            Navigator.pushNamed(context, RouteNames.tailor_cart_screen),
      ),

      body: BlocProvider(
        create: (_) => getIt<CartCubit>(),
        child: CartScreenBody(),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'tailor',
        selectedIndex: 3,
      ),
    );
  }
}
