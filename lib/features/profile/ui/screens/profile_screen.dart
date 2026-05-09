import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/profile/logic/profile_cubit.dart';
import 'package:chicora/features/profile/logic/profile_state.dart';
import 'package:chicora/features/profile/ui/widget/profile_identity_header.dart';
import 'package:chicora/features/profile/ui/widget/profile_menu_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    final role = await prefs.getSecureData(SharedPrefKey.role);

    if (!mounted) return;
    setState(() {
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
                    success: (data) => data is ProfileResponse ? data : null,
                    orElse: () => null,
                  );
                  final isLoading = state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );

                  return ProfileIdentityHeader(
                    profile: profile,
                    isLoading: isLoading,
                    primaryColor: _primaryColor,
                    darkColor: _darkColor,
                    lightColor: _lightColor,
                    onEditProfile: (p) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileCubit>(),
                            child: EditProfileScreen(
                              profile: p,
                              primaryColor: _primaryColor,
                              lightColor: _lightColor,
                            ),
                          ),
                        ),
                      );
                    },
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