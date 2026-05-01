import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/style.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import '../../data/repo/portfolio_tailor_repo.dart';
import '../../logic/cubit/portfolio_tailor_cubit.dart';
import '../widgets/portfolio_tailor_body.dart';

class PortfolioTailorScreen extends StatelessWidget {
  const PortfolioTailorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PortfolioTailorCubit(
        portfolioTailorRepo: getIt<PortfolioTailorRepo>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: "Your Portfolio",
          style: AppStyle.boldSecondary,
          showCartIcon: true,
          onCartTap: () =>
              Navigator.pushNamed(context, RouteNames.tailor_cart_screen),
        ),
        body: PortfolioTailorBody(),
        bottomNavigationBar: FloatingNavBar(
          userRole: 'tailor',
          selectedIndex: 1,
         focused: AppColors.secondary,
        notSelected: AppColors.darksecondary,
        ),
      ),
    );
  }
}
