import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/circle_indicator.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/pinterest_grid.dart';
import '../../../../../core/widgets/pinterest_grid_config.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});
  final prefs = getIt<SharedPrefHelper>();

  String _formatDate(dynamic dateValue) {
    try {
      late DateTime dateTime;
      if (dateValue is DateTime) {
        dateTime = dateValue;
      } else if (dateValue is String) {
        dateTime = DateTime.parse(dateValue);
      } else {
        return 'N/A';
      }
      // Return formatted date: 2026-02-17
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Your Requests",
        style: AppStyle.medPrimery,
        leadingIcon: Icons.arrow_back,
        leading: true,
        showCartIcon: true,
        onCartTap: () =>
            Navigator.pushNamed(context, RouteNames.customer_cart_screen),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  CustomElevatedButton(
                    value: "+ New Request",
                    style: AppStyle.medBackground,
                    height: 25.h,
                    width: 200.w,
                    onPressed: () {
                      Navigator.pushNamed(context, "upload_post");
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<CustomerBiddingCubit>().getMyBids();
                    });
                    return BlocBuilder<
                      CustomerBiddingCubit,
                      CustomerBiddingState
                    >(
                      builder: (context, state) {
                        return state.when(
                          initial: () => Center(child: circleIndicator()),
                          loading: () => Center(child: circleIndicator()),
                          fail: (msg) => Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('failed to retrive the posts'),
                                const SizedBox(height: 8),
                                CustomElevatedButton(
                                  onPressed: () => context
                                      .read<CustomerBiddingCubit>()
                                      .getMyBids(),
                                  value: 'Retry',
                                ),
                              ],
                            ),
                          ),
                          success: (data) {
                            if (data is List<BidResponse>) {
                              final bids = data;
                              if (bids.isEmpty) {
                                return const Center(
                                  child: Text('No posts available'),
                                );
                              }
                              return PinterestGrid<BidResponse>(
                                items: bids,
                                mainColor: AppColors.ternary,
                                darkColor: AppColors.ternary,
                                onTap: (post) => Navigator.pushNamed(
                                  context,
                                  "post_details",
                                  arguments: {
                                    'bidId': post.id,
                                    'urlImage': post.imageUrl,
                                    'description': post.requestDescription,
                                  },
                                ),
                                configBuilder: (post) => PinterestCardConfig(
                                  imageUrl: post.imageUrl,
                                  name: post.requestDescription,
                                  status: post.status,
                                  price: post.price
                                      ?.toInt(), // adjust to your model field
                                  bidsDate: _formatDate(
                                    post.createdAt,
                                  ), // adjust to your model field
                                  showStatus: true,
                                  showPrice: true,
                                  showBidsCount: false,
                                  showDate: true,
                                  showCart: false,
                                  showRating: false,
                                  showEdit: false,
                                ),
                              );
                            }
                            return const Center(child: Text('Unexpected data'));
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'customer',
        selectedIndex: 1,
        focused: AppColors.primery,
        notSelected: AppColors.darkprimery,
      ),
    );
  }
}
