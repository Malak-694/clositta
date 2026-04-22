import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../router/route_names.dart';

class FloatingNavBar extends StatelessWidget {
  final String userRole;
  final int selectedIndex;
  final Color focused;
  final Color notSelected;
  const FloatingNavBar({
    super.key,
    required this.userRole,
    required this.selectedIndex,
    this.focused = AppColors.primery,
    this.notSelected = AppColors.darkprimery,
  });

  Map<String, List<Map<String, dynamic>>> get roleNavItems => {
    "customer": [
      {
        "icon": Icons.home,
        "name": "Home",
        "route": RouteNames.customer_products_screen,
      },
      {"icon": Icons.star, "name": "AI", "route": RouteNames.posts_customer},
      {
        "icon": Icons.checkroom,
        "name": "closet",
        "route": RouteNames.closet_items_screen,
      },
      {
        "icon": Icons.request_page,
        "name": "Biddings",
        "route": RouteNames.posts_customer,
      },

      {
        "icon": Icons.person,
        "name": "Profile",
        "route": RouteNames.profile_customer_screen,
      },
    ],
    "tailor": [
      {
        "icon": Icons.home,
        "name": "Home",
        "route": RouteNames.view_bidding_tailor,
      },
      {
        "icon": Icons.cut,
        "name": "Portfolio",
        "route": RouteNames.portfolio_tailor_screen,
      },

      {
        "icon": Icons.person,
        "name": "Profile",
        "route": RouteNames.profile_tailor_screen,
      },
      {
        "icon": Icons.shopping_bag,
        "name": "Shop",
        "route": RouteNames.tailor_products_screen,
      },
    ],
    "seller": [
      {
        "icon": Icons.home,
        "name": "Products",
        "route": RouteNames.seller_products_screen,
      },
      {
        "icon": Icons.cut,
        "name": "Portfolio",
        "route": RouteNames.seller_products_screen,
      },

      {
        "icon": Icons.person,
        "name": "Profile",
        "route": RouteNames.profile_seller_screen,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final navItems = roleNavItems[userRole] ?? roleNavItems["customer"]!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12),
      child: Container(
        height: 65.h,
        width: 380.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          child: BottomAppBar(
            padding: EdgeInsets.all(4.r),
            color: AppColors.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name !=
                        item["route"]) {
                      Navigator.pushNamed(context, item["route"]);
                    }
                  },
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: isSelected ? 1.0 : 0.8,
                      end: isSelected ? 1.2 : 0.9,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              item["icon"],
                              color: isSelected ? focused : notSelected,
                              size: item["name"] == "Profile" ? 34.r : 32.r,
                            ),
                            Text(
                              item["name"],
                              style: TextStyle(
                                color: isSelected ? focused : notSelected,
                                fontSize: 12.r,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
