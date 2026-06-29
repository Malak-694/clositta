import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/customer/measurements/ui/widgets/measurements_profile_tile.dart';
import 'package:chicora/features/profile/data/model/profile_model.dart';
import 'package:chicora/features/profile/logic/cubit/profile_cubit.dart';
import 'package:chicora/features/profile/ui/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuList extends StatelessWidget {
  final String? role;
  final ProfileResponse? profile;
  final Color primaryColor;
  final Color lightColor;

  const ProfileMenuList({
    super.key,
    required this.role,
    this.profile,
    required this.primaryColor,
    required this.lightColor,
  });

  bool get _isCustomer => role?.toLowerCase() == 'customer';

  List<Map<String, dynamic>> get _menuItems {
    switch (role?.toLowerCase()) {
      case 'tailor':
        return [
          // {
          //   'icon': Icons.location_on_outlined,
          //   'title': 'Set Location',
          //   'subtitle': 'Update your workshop address',
          //   'route': null,
          //   'arguments': null,
          // },
          {
            'icon': Icons.history_outlined,
            'title': 'Order History',
            'subtitle': 'Completed tailoring jobs',
            'route': null,
            'arguments': null,
          },
          {
            'icon': Icons.notifications_outlined,
            'title': 'Notification Preferences',
            'subtitle': 'Manage your alerts',
            'route': RouteNames.notification_preferences_screen,
            'arguments': null,
          },
        ];
      case 'clothes_seller':
      case 'material_seller':
      case 'seller':
        return [
          {
            'icon': Icons.receipt_long_outlined,
            'title': 'Order History',
            'subtitle': 'Track sales & transactions',
            'route': RouteNames.seller_orders_screen,
            'arguments': null,
          },
          {
            'icon': Icons.notifications_outlined,
            'title': 'Notification Preferences',
            'subtitle': 'Manage your alerts',
            'route': RouteNames.notification_preferences_screen,
            'arguments': null,
          },
        ];
      default:
        return [
          {
            'icon': Icons.shopping_bag_outlined,
            'title': 'My Shop',
            'subtitle': 'View your orders.',
            'route': RouteNames.order_view_screen,
            'arguments': {'fromCart': false},
          },
          {
            'icon': Icons.notifications_outlined,
            'title': 'Notification Preferences',
            'subtitle': 'Manage your alerts',
            'route': RouteNames.notification_preferences_screen,
            'arguments': null,
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _menuItems;
    final customerExtraItems = _isCustomer ? 1 : 0;

    return ListView.separated(
      shrinkWrap: false,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: items.length + 2 + customerExtraItems,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        if (_isCustomer && index == items.length) {
          return MeasurementsProfileTile(
            primaryColor: primaryColor,
            lightColor: lightColor,
          );
        }

        // Edit Profile tile
        if (index == items.length + customerExtraItems) {
          return _buildMenuCard(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            subtitle: 'Name, Email, Phone',
            primaryColor: primaryColor,
            lightColor: lightColor,
            onTap: () {
              if (profile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Profile not loaded yet, please wait.')),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      BlocProvider.value(
                        value: context.read<ProfileCubit>(),
                        child: EditProfileScreen(
                          profile: profile!,
                          primaryColor: primaryColor,
                          lightColor: lightColor,
                        ),
                      ),
                ),
              );
            },
          );
        }

        // Logout tile
        if (index == items.length + customerExtraItems + 1) {
          return _buildLogoutCard(context);
        }

        // Regular menu items
        final item = items[index];
        return _buildMenuCard(
            icon: item['icon'] as IconData,
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
            primaryColor: primaryColor,
            lightColor: lightColor,
            onTap: () {
              final route = item['route'] as String?;
              final arguments = item['arguments'] as Map<String, dynamic>?;  // ← read it
              if (route != null) {
                Navigator.of(context).pushNamed(
                  route,
                  arguments: arguments,   // ← pass it
                );
              }
            }
        );
      },
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color primaryColor,
    required Color lightColor,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      // ← adds space on both sides
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: primaryColor, size: 24.sp),
          ),
          title: Text(
            title,
            style: AppStyle.body3.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: AppStyle.medLight.copyWith(fontSize: 13.sp),
          ),
          trailing: Icon(
              Icons.chevron_right, color: AppColors.light, size: 24.sp),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildLogoutCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (dialogContext) =>
              AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Logout'),
                  ),
                ],
              ),
        );

        if (shouldLogout != true) return;

        final prefs = getIt<SharedPrefHelper>();
        await prefs.clearAll();
        await prefs.clearAllSecure();

        if (!context.mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteNames.login,
              (route) => false,
        );
      },
      child: Container(
        height: 80.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // ← centers content
          children: [
            Icon(Icons.logout, color: AppColors.ternary, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              "Logout",
              style: AppStyle.body3.copyWith(
                color: AppColors.ternary,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}