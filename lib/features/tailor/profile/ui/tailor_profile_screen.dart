import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/profile/logic/profile_cubit.dart';
import 'package:chicora/features/profile/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TailorProfileScreen extends StatelessWidget {
  const TailorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..getProfile(), // 👈
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: const ProfileScreen(),
        bottomNavigationBar: FloatingNavBar(
          userRole: 'tailor',
          selectedIndex: 2,
          focused: AppColors.primery,
          notSelected: AppColors.darkprimery,
        ),
      ),
    );
  }
}