import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/constants.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/customer/biding/ui/Screens/detailes_screen.dart';
import 'package:chicora/features/tailor/bidding_tailor/ui/widgets/post_item_tailor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/custom_app_bar.dart';

class PostScreenTailor extends StatelessWidget {
  PostScreenTailor({super.key});
  final prefs = getIt<SharedPrefHelper>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Post",
        leading: true,
        leadingIcon: Icons.arrow_back,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 15.h),

                    PostItemTailor(
                      title:
                          'White floral summer dress, knee-length, with short sleeves',
                      bidCount: 3,
                      date: '11/28/2025',
                      price: '100\$',
                      period: '10 days',
                      Image_url: "assets/images/clothes2.png",
                      status: "selected",
                    ),

                    SizedBox(height: 15.h),
                    PostItemTailor(
                      title:
                          'White floral summer dress, knee-length, with short sleeves',
                      price: '100\$',
                      period: '10 days',
                      bidCount: 3,
                      date: '11/28/2025',
                      Image_url: "assets/images/dress.png",
                      status: "open",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FutureBuilder<String?>(
        future: prefs.getSecureData(SharedPrefKey.role),
        builder: (context, snapshot) {
          final role = snapshot.data ?? "Customer";
          return FloatingNavBar(userRole: role, selectedIndex: 0);
        },
      ),
    );
  }
}