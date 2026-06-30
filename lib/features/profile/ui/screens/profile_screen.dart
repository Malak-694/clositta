import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/profile/data/model/profile_model.dart';
import 'package:chicora/features/profile/logic/cubit/profile_cubit.dart';
import 'package:chicora/features/profile/logic/cubit/profile_state.dart';
import 'package:chicora/features/profile/ui/screens/edit_profile_screen.dart';
import 'package:chicora/features/profile/ui/widget/profile_identity_header.dart';
import 'package:chicora/features/profile/ui/widget/profile_menu_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _role;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
    context.read<ProfileCubit>().getProfile();
  }

  Future<void> _initAndLoad() async {
    final prefs = getIt<SharedPrefHelper>();
    final role = await prefs.getSecureData(SharedPrefKey.role);
    if (!mounted) return;
    setState(() => _role = role);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ChicoraApp.of(context).isDarkMode;
    final scaffoldColor = isDark
        ? AppColors.darkScaffold
        : AppColors.lightprimery.withOpacity(0.40);

    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final profile = state.maybeWhen(
                success: (data) => data is ProfileResponse ? data : null,
                orElse: () => null,
              );
              final isLoading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );

              return Column(
                children: [
                  ProfileIdentityHeader(
                    profile: profile,
                    isLoading: isLoading,
                    primaryColor: isDark ? AppColors.darkPrimary : AppColors.primery,
                    darkColor: isDark ? AppColors.darkPrimaryLight : AppColors.darkprimery,
                    lightColor: isDark ? AppColors.darkPrimaryTint : AppColors.lightprimery,
                    isDarkMode: isDark,
                    onThemeToggle: () => ChicoraApp.of(context).toggleTheme(),
                    onEditProfile: (p) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileCubit>(),
                            child: EditProfileScreen(
                              profile: p,
                              primaryColor: isDark ? AppColors.darkPrimary : AppColors.primery,
                              lightColor: isDark ? AppColors.darkPrimaryTint : AppColors.lightprimery,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: Center(
                      child: ProfileMenuList(
                        role: _role,
                        profile: profile,
                        primaryColor: isDark ? AppColors.darkPrimary : AppColors.primery,
                        lightColor: isDark ? AppColors.darkPrimaryTint : AppColors.lightprimery,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
