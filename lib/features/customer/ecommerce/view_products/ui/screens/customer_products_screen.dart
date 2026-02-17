import 'package:flutter/material.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/custom_nav_bar.dart';
import '../widgets/customer_product_screen_body.dart';

class CustomerProductsScreen extends StatelessWidget {
  const CustomerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Welcome to Clositta"),

      body: CustomerProductScreenBody(),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'customer',
        selectedIndex: 0,
        focused: AppColors.primery,
        notSelected: AppColors.darkprimery,
      ),
    );
  }
}
