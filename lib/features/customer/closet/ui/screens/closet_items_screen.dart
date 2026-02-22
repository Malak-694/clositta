import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import '../../data/repo/closet_repo.dart';
import '../../logic/cubit/closet_cubit.dart';
import '../widgets/closet_items_body.dart';

class ClosetItemsScreen extends StatelessWidget {
  const ClosetItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClosetCubit(closetRepo: getIt<ClosetRepo>()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: "Your Closet"),
        body: ClosetItemsScreenBody(),
        bottomNavigationBar: FloatingNavBar(
          userRole: 'customer',
          selectedIndex: 2,
          focused: AppColors.primery,
          notSelected: AppColors.darkprimery,
        ),
      ),
    );
  }
}
