// profile_menu_list.dart
import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/order_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuList extends StatelessWidget {
  final String? role;
  final Color primaryColor;
  final Color lightColor;

  const ProfileMenuList({
    super.key,
    required this.role,
    required this.primaryColor,
    required this.lightColor,
  });

  List<Map<String, dynamic>> get _menuItems {
    final common = [
      {'icon': Icons.credit_card_outlined, 'title': 'Payment Methods'},
      {'icon': Icons.notifications_outlined, 'title': 'Notifications'},
      {'icon': Icons.settings_outlined, 'title': 'Settings'},
      {'icon': Icons.help_outline, 'title': 'Help & Support'},
    ];

    switch (role?.toLowerCase()) {
      case 'tailor':
        return [
          {'icon': Icons.shopping_bag_outlined, 'title': 'My Shop'},
          ...common,
        ];
      case 'clothes_seller':
      case 'material_seller':
        return [
          ...common,
        ];
      default: // customer
        return [
          {'icon': Icons.shopping_bag_outlined, 'title': 'My Orders'},
          ...common,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _menuItems;

    return ListView.separated(
      shrinkWrap: false,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length + 1, // +1 for logout
      separatorBuilder: (_, __) => Divider(
        height: 3,
        thickness: 1,
        color: Colors.grey.shade200,
      ),
      itemBuilder: (context, index) {
        // Logout tile
        if (index == items.length) {
          return Container(
            height: 90.h,
            color: AppColors.background,
            child: Center(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 4.h,
                ),
                leading: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 30.sp,
                  ),
                ),
                title: Text(
                  "Logout",
                  style: AppStyle.body3.copyWith(color: Colors.red),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppColors.light,
                  size: 30.sp,
                ),
                onTap: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text(
                        'Are you sure you want to logout?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(true);
                          },
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
                    RouteNames.sing_up,
                    (route) => false,
                  );
                },
              ),
            ),
          );
        }

        final item = items[index];
        return Container(
          height: 90.h,
          color: AppColors.background,
          child: Center(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 4.h,
              ),
              leading: Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: primaryColor,
                  size: 30.sp,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: AppStyle.body3,
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.light,
                size: 30.sp,
              ),
              onTap: () {
                if ((item['title'] as String) == 'My Orders') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OrderViewScreen(),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}