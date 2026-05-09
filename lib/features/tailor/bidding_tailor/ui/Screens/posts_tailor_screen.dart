import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/constants.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/tailor/bidding_tailor/ui/widgets/post_item_tailor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/post_tailor_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../assets.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/circle_indicator.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../chat/ui/screens/conversations_screen.dart';

class PostScreenTailor extends StatelessWidget {
  PostScreenTailor({super.key});
  final prefs = getIt<SharedPrefHelper>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Post",
        showCartIcon: true,
        onCartTap: () =>
            Navigator.pushNamed(context, RouteNames.tailor_cart_screen),
        showChatIcon: true,
        unreadChatCount: 5,   // pass 0 if no unread
        onChatTap: () async {
          final userId = await prefs.getSecureData('id') ?? '';
          if (context.mounted) {
            Navigator.pushNamed(
              context,
              RouteNames.conversations_screen,
              arguments: {
                'currentUserId': userId,
              },
            );
          }
        },
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
                child: Builder(
                  builder: (context) {
                    // Trigger load once when the screen is built
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<BiddingTailorCubit>().getBiddingTailors();
                    });

                    return BlocBuilder<BiddingTailorCubit, BiddingTailorState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => Center(child: circleIndicator()),
                          loading: () => Center(child: circleIndicator()),

                          fail: (msg) => Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('failed to retrive the bidding'),
                                const SizedBox(height: 8),
                                CustomElevatedButton(
                                  onPressed: () => context
                                      .read<BiddingTailorCubit>()
                                      .getBiddingTailors(),
                                  value: 'Retry',
                                ),
                              ],
                            ),
                          ),
                          success: (data) {
                            if (data is List<PostTailorResponse>) {
                              final posts = data;
                              if (posts.isEmpty) {
                                return Center(
                                  child: Text('No posts available'),
                                );
                              }
                              return ListView.separated(
                                padding: EdgeInsets.only(top: 15.h),
                                itemCount: posts.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 15.h),
                                itemBuilder: (context, index) {
                                  final post = posts[index];
                                  return GestureDetector(
                                    onTap: () => post.status != "closed"
                                        ? Navigator.pushNamed(
                                      context,
                                      RouteNames.view_offers_tailor,
                                      arguments: {
                                        'urlImage':
                                        post.imageUrl ??
                                            Assets.clothes1,

                                        'description':
                                        post.requestDescription ?? '',
                                        'price': post.price.toString(),
                                        'period': post.time ?? '',
                                        'postId': post.id ?? '',
                                      },
                                    )
                                        : null,
                                    child: PostItemTailor(
                                      title: post.requestDescription ?? '',
                                      bidCount: 0,
                                      date: post.createdAt ?? '',
                                      price: post.price != null
                                          ? '\$${post.price}'
                                          : '',
                                      period: post.time ?? '',
                                      Image_url:
                                      post.imageUrl ?? Assets.clothes1,
                                      status: post.status ?? 'selected',
                                      id: post.id ?? '',
                                    ),
                                  );
                                },
                              );
                            }

                            return Center(child: Text('Unexpected data'));
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
        userRole: 'tailor',
        selectedIndex: 0,
      ),
    );
  }
}
