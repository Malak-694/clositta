import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import '../widgets/seller_product_screen_body.dart';

class SellerProductsScreen extends StatelessWidget {
  final prefs = getIt<SharedPrefHelper>();

  SellerProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "My Products",
        showCartIcon: false,
        onCartTap: () {},
      ),
      body: BlocProvider(
        create: (context) => getIt<SellerProductsCubit>()..getProducts(),
        child: SellerProductScreenBody(),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'seller',
        selectedIndex: 0,
        focused: AppColors.ternary,
        notSelected: AppColors.darkternary,
      ),
    );
  }
}
