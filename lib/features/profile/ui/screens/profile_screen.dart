import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/circle_indicator.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_state.dart' hide Success;
import 'package:chicora/features/profile/logic/profile_cubit.dart';
import 'package:chicora/features/profile/logic/profile_state.dart';
import 'package:chicora/features/profile/ui/widget/profile_menu_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/networking/api_result.dart';
import '../../data/model/profile_model.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color _primaryColor = AppColors.primery;
  Color _darkColor    = AppColors.darkprimery;
  Color _lightColor   = AppColors.lightprimery;

  String? _role;
  String? _token;

  @override
  void initState() {
    super.initState();


    AppColors.primaryForCurrentUser().then((color) {
      if (!mounted) return;
      setState(() => _primaryColor = color);
    });

    AppColors.darkForCurrentUser().then((color) {
      if (!mounted) return;
      setState(() => _darkColor = color);
    });

    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    final prefs = getIt<SharedPrefHelper>();

    final token = await prefs.getSecureData(SharedPrefKey.token);
    final role  = await prefs.getSecureData(SharedPrefKey.role);

    if (!mounted) return;
    setState(() {
      _token      = token;
      _role       = role;
      _lightColor = _lightColorForRole(role);
    });

  }

  // 👇 only this needs a custom function since it's not in AppColors
  Color _lightColorForRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'tailor':           return AppColors.lightsecondary;
      case 'clothes_seller':
      case 'material_seller':  return AppColors.lightternary;
      case 'admin':            return Colors.red.shade100;
      default:                 return AppColors.lightprimery;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _lightColor.withOpacity(0.50),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final profile = state.maybeWhen(
                    success: (data) => data is ProfileResponse ? data : null, // 👈
                    orElse: () => null,
                  );
                  final isLoading = state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );

                  return Container(
                    width: double.infinity,
                    height: 120.h,
                    color: AppColors.background,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 45.r,
                          backgroundColor: _lightColor,
                          backgroundImage: profile?.imageUrl != null
                              ? NetworkImage(profile!.imageUrl!)
                              : null,
                          child: profile?.imageUrl == null
                              ? Icon(
                            Icons.person,
                            size: 45.sp,
                            color: _primaryColor,
                          )
                              : null,
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: isLoading
                              ? Center(child: circleIndicator())
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.name ?? "—",
                                style: AppStyle.medBlack
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                profile?.email ?? "—",
                                style: AppStyle.medLight.copyWith(fontSize: 14)
                              ),
                              SizedBox(height: 6.h),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (profile != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<ProfileCubit>(),
                                    child: EditProfileScreen(
                                      profile: profile!,
                                      primaryColor: _primaryColor,
                                      lightColor: _lightColor,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.edit,
                            size: 28.sp,
                            color: _primaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 30.h),

              // Menu List
              Expanded(
                child: ProfileMenuList(
                  role: _role,
                  primaryColor: _primaryColor,
                  lightColor: _lightColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}