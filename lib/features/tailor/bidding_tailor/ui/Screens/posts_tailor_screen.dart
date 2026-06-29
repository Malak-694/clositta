import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/constants.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
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
import '../../../../chat/data/models/conversation_model.dart';
import '../../../../chat/logic/conversations_cubit/conversations_cubit.dart';
import '../../../../chat/logic/conversations_cubit/conversations_state.dart';
import '../../../../chat/ui/screens/conversations_screen.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_state.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import '../../../../notifications/data/models/unread_count_response.dart';
import '../../../../notifications/logic/cubit/notification_cubit.dart';

class PostScreenTailor extends StatelessWidget {
  PostScreenTailor({super.key});
  final prefs = getIt<SharedPrefHelper>();

  @override
  Widget build(BuildContext context) {

    final cartCount   = cartTotalItemQuantity(context.watch<CartCubit>().state);
    final chatCount   = context.watch<ConversationsCubit>().unreadCount;
    final notifCount  = context.watch<NotificationCubit>().state.maybeWhen(
      success: (data) => data is UnreadCountResponse ? data.unreadCount : 0,
      orElse: () => 0,
    );


    return Scaffold(
      appBar: CustomAppBar(
      title: 'My Post',
      showCartIcon: true,
      cartItemCount: cartCount,
      onCartTap: () => Navigator.pushNamed(context, RouteNames.customer_cart_screen),
      showNotificationIcon: true,
      unreadNotificationCount: notifCount,
      onNotificationTap: () => Navigator.pushNamed(context, RouteNames.notification_screen),
      showChatIcon: true,
      unreadChatCount: chatCount,
      onChatTap: () async {
        final userId = await prefs.getSecureData('id') ?? '';
        Navigator.pushNamed(
        context,
        RouteNames.conversations_screen,
        arguments: {'currentUserId': userId ?? ''},
      );
      }
    ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {

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
                                separatorBuilder: (_, _) =>
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
                                    child: Center(
                                      child: PostItemTailor(
                                        title: post.requestDescription ?? '',
                                        bidCount: 0 ,
                                        date: post.createdAt ?? '',
                                        price: post.price != null
                                            ? '\$${post.price}'
                                            : '',
                                        period: post.time ?? 'Flexible',
                                        Image_url:
                                        post.imageUrl ?? Assets.clothes1,
                                        status: post.status ?? 'selected',
                                        id: post.id ?? '',
                                      ),
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
