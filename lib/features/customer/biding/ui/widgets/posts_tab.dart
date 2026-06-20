import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/circle_indicator.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/pinterest_grid.dart';
import 'package:chicora/core/widgets/pinterest_grid_config.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/router/route_names.dart';
import '../../../../auth/ui/widgets/drop_down_type.dart';

class PostsTab extends StatefulWidget {
  final ValueChanged<List<BidResponse>> onBidsLoaded;

  const PostsTab({super.key, required this.onBidsLoaded});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  final List<String> _categories = ["All", "Open", "Updated", "Closed"];
  String _selectedCategory = "All";

  String _formatDate(dynamic dateValue) {
    try {
      final dateTime = dateValue is DateTime
          ? dateValue
          : DateTime.parse(dateValue as String);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return 'N/A';
    }
  }

  List<BidResponse> _filterBids(List<BidResponse> bids) {
    if (_selectedCategory == "All") return bids;
    return bids
        .where((b) =>
    b.status.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
      child: Column(
        children: [
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
                            const Text('Failed to retrieve the posts'),
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            widget.onBidsLoaded(data);
                          });

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
                              showEdit:
                              post.status.toLowerCase() != 'closed',
                              onEdit: post.status.toLowerCase() != 'closed'
                                  ? () => Navigator.pushNamed(
                                context,
                                RouteNames.upload_post,
                                arguments: {
                                  'bidId': post.id,
                                  'initialDescription':
                                  post.requestDescription,
                                  'initialImageUrl': post.imageUrl,
                                  'initialPrice': post.price,
                                },
                              )
                                  : null,
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
          CustomElevatedButton(
            value: "+ New Post",
            style: AppStyle.medBackground,
            height: 50.h,
            width: 370.w,
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.upload_post),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}