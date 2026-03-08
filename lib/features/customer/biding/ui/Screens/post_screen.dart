import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
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

import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/pinterest_grid.dart';
import '../../../../../core/widgets/pinterest_grid_config.dart';
import '../../../../auth/ui/widgets/drop_down_type.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final prefs = getIt<SharedPrefHelper>();

  final List<String> _categories = ["All", "Open", "Updated", "Closed"];
  String _selectedCategory = "All";

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
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  List<BidResponse> _filterBids(List<BidResponse> bids) {
    if (_selectedCategory == "All") return bids;
    return bids
        .where((b) => b.status.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
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
              // ── Top Row: Dropdown + New Request ──────────────────
              Row(
                children: [
                  CustomDropdown(
                    value: _selectedCategory,
                    hintText: "Filter",
                    items: _categories,
                    width: 140,
                    vPadding: 8,
                    style: AppStyle.medPrimery,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    value: "+ New Post",
                    style: AppStyle.medBackground,
                    height: 50.h,
                    width: 200.w,
                    onPressed: () {
                      Navigator.pushNamed(context, "upload_post");
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // ── Bids Grid ────────────────────────────────────────
              Expanded(
                child: Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<CustomerBiddingCubit>().getMyBids();
                    });
                    return BlocBuilder<CustomerBiddingCubit, CustomerBiddingState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => Center(child: circleIndicator()),
                          loading: () => Center(child: circleIndicator()),
                          fail: (msg) => Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Failed to retrieve the posts'),
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
                              final filteredBids = _filterBids(data);

                              if (filteredBids.isEmpty) {
                                return Center(
                                  child: Text(
                                    _selectedCategory == "All"
                                        ? 'No posts available'
                                        : 'No $_selectedCategory requests',
                                    style: AppStyle.medLight,
                                  ),
                                );
                              }

                              return PinterestGrid<BidResponse>(
                                items: filteredBids,
                                mainColor: AppColors.ternary,
                                darkColor: AppColors.ternary,
                                onTap: (post) => Navigator.pushNamed(
                                  context,
                                  "post_details",
                                  arguments: {
                                    'bidId': post.id,
                                    'urlImage': post.imageUrl,
                                    'description': post.requestDescription,
                                    'status': post.status,
                                  },
                                ),
                                configBuilder: (post) => PinterestCardConfig(
                                  imageUrl: post.imageUrl,
                                  name: post.requestDescription,
                                  status: post.status,
                                  price: post.price?.toInt(),
                                  bidsDate: _formatDate(post.createdAt),
                                  showStatus: true,
                                  showPrice: true,
                                  showBidsCount: false,
                                  showDate: true,
                                  showCart: false,
                                  showRating: false,
                                  // ✅ Only show edit for open posts
                                  showEdit: post.status.toLowerCase() != 'closed',
                                  onEdit: post.status.toLowerCase() != 'closed'
                                      ? () => Navigator.pushNamed(
                                    context,
                                    RouteNames.upload_post,
                                    arguments: {
                                      'bidId': post.id,
                                      'initialDescription': post.requestDescription,
                                      'initialImageUrl': post.imageUrl,
                                      'initialPrice': post.price,
                                    },
                                  ) : null,
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