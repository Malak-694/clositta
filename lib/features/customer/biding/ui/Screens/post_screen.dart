import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/circle_indicator.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/router/route_names.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/pinterest_grid.dart';
import '../../../../../core/widgets/pinterest_grid_config.dart';
import '../../../../auth/ui/widgets/drop_down_type.dart';
import '../../../../chat/data/models/conversation_model.dart';
import '../../../../chat/logic/conversations_cubit/conversations_cubit.dart';
import '../../../../chat/logic/conversations_cubit/conversations_state.dart';
import '../widgets/active_orders_tab.dart';
import '../widgets/posts_tab.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}
//
// class _PostScreenState extends State<PostScreen> {
//   final prefs = getIt<SharedPrefHelper>();
//   String? _currentUserId;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     context.read<ConversationsCubit>().loadUnreadCount();
//   }
//
//   Future<void> _loadUserId() async {
//     final prefs = getIt<SharedPrefHelper>();
//     final id = await prefs.getSecureData(SharedPrefKey.id);
//     if (!mounted) return;
//     setState(() => _currentUserId = id);
//   }
//
//   final List<String> _categories = ["All", "Open", "Updated", "Closed"];
//   String _selectedCategory = "All";
//
//   String _formatDate(dynamic dateValue) {
//     try {
//       late DateTime dateTime;
//       if (dateValue is DateTime) {
//         dateTime = dateValue;
//       } else if (dateValue is String) {
//         dateTime = DateTime.parse(dateValue);
//       } else {
//         return 'N/A';
//       }
//       return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return 'N/A';
//     }
//   }
//
//   List<BidResponse> _filterBids(List<BidResponse> bids) {
//     if (_selectedCategory == "All") return bids;
//     return bids
//         .where((b) => b.status.toLowerCase() == _selectedCategory.toLowerCase())
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(kToolbarHeight),
//         child: BlocBuilder<CartCubit, CartState<dynamic>>(
//           builder: (context, cartState) {
//             return BlocBuilder<ConversationsCubit,
//                 ConversationsState<List<ConversationModel>>>(
//               builder: (context, convState) {
//                 final unreadCount = context.read<ConversationsCubit>().unreadCount;
//
//                 return CustomAppBar(
//                   title: "Your Biddings",
//                   showCartIcon: true,
//                   cartItemCount: cartTotalItemQuantity(cartState),
//                   onCartTap: () => Navigator.pushNamed(
//                     context,
//                     RouteNames.customer_cart_screen,
//                   ),
//                   showChatIcon: true,
//                   unreadChatCount: unreadCount,
//                   onChatTap: () => Navigator.pushNamed(
//                     context,
//                     RouteNames.conversations_screen,
//                     arguments: {
//                       'currentUserId': _currentUserId ?? '',
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: Container(
//           height: double.infinity,
//           width: double.infinity,
//           padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: CustomDropdown(
//                       value: _selectedCategory,
//                       hintText: "Filter",
//                       items: _categories,
//                       width: 50.w,
//                       vPadding: 11.h,
//                       style: AppStyle.medPrimery,
//                       onChanged: (value) {
//                         if (value != null) {
//                           setState(() => _selectedCategory = value);
//                         }
//                       },
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   CustomElevatedButton(
//                     value: "+ New Post",
//                     style: AppStyle.medBackground,
//                     height: 50.h,
//                     width: 200.w,
//                     onPressed: () {
//                       Navigator.pushNamed(context, "upload_post");
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               Expanded(
//                 child: Builder(
//                   builder: (context) {
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       context.read<CustomerBiddingCubit>().getMyBids();
//                     });
//                     return BlocBuilder<
//                       CustomerBiddingCubit,
//                       CustomerBiddingState
//                     >(
//                       builder: (context, state) {
//                         return state.when(
//                           initial: () => Center(child: circleIndicator()),
//                           loading: () => Center(child: circleIndicator()),
//                           fail: (msg) => Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text('Failed to retrieve the posts'),
//                                 const SizedBox(height: 8),
//                                 CustomElevatedButton(
//                                   onPressed: () => context
//                                       .read<CustomerBiddingCubit>()
//                                       .getMyBids(),
//                                   value: 'Retry',
//                                 ),
//                               ],
//                             ),
//                           ),
//                           success: (data) {
//                             if (data is List<BidResponse>) {
//                               final filteredBids = _filterBids(data);
//
//                               if (filteredBids.isEmpty) {
//                                 return Center(
//                                   child: Text(
//                                     _selectedCategory == "All"
//                                         ? 'No posts available'
//                                         : 'No $_selectedCategory requests',
//                                     style: AppStyle.medLight,
//                                   ),
//                                 );
//                               }
//
//                               return PinterestGrid<BidResponse>(
//                                 items: filteredBids,
//                                 mainColor: AppColors.ternary,
//                                 darkColor: AppColors.ternary,
//                                 onTap: (post) => Navigator.pushNamed(
//                                   context,
//                                   "post_details",
//                                   arguments: {
//                                     'bidId': post.id,
//                                     'urlImage': post.imageUrl,
//                                     'description': post.requestDescription,
//                                     'status': post.status,
//                                   },
//                                 ),
//                                 configBuilder: (post) => PinterestCardConfig(
//                                   imageUrl: post.imageUrl,
//                                   name: post.requestDescription,
//                                   status: post.status,
//                                   price: post.price?.toInt(),
//                                   bidsDate: _formatDate(post.createdAt),
//                                   showStatus: true,
//                                   showPrice: true,
//                                   showBidsCount: false,
//                                   showDate: true,
//                                   showCart: false,
//                                   showRating: false,
//                                   // ✅ Only show edit for open posts
//                                   showEdit:
//                                       post.status.toLowerCase() != 'closed',
//                                   onEdit: post.status.toLowerCase() != 'closed'
//                                       ? () => Navigator.pushNamed(
//                                           context,
//                                           RouteNames.upload_post,
//                                           arguments: {
//                                             'bidId': post.id,
//                                             'initialDescription':
//                                                 post.requestDescription,
//                                             'initialImageUrl': post.imageUrl,
//                                             'initialPrice': post.price,
//                                           },
//                                         )
//                                       : null,
//                                 ),
//                               );
//                             }
//                             return const Center(child: Text('Unexpected data'));
//                           },
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: FloatingNavBar(
//         userRole: 'customer',
//         selectedIndex: 3,
//       ),
//     );
//   }
// }


class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  final prefs = getIt<SharedPrefHelper>();
  String? _currentUserId;
  late TabController _tabController;
  List<BidResponse> _allBids = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserId();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final id = await prefs.getSecureData(SharedPrefKey.id);
    if (!mounted) return;
    setState(() => _currentUserId = id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<CartCubit, CartState<dynamic>>(
          builder: (context, cartState) {
            return BlocBuilder<ConversationsCubit,
                ConversationsState<List<ConversationModel>>>(
              builder: (context, convState) {
                final unreadCount =
                    context.read<ConversationsCubit>().unreadCount;
                return CustomAppBar(
                  title: "Your Biddings",
                  showCartIcon: true,
                  cartItemCount: cartTotalItemQuantity(cartState),
                  onCartTap: () => Navigator.pushNamed(
                      context, RouteNames.customer_cart_screen),
                  showChatIcon: true,
                  unreadChatCount: unreadCount,
                  onChatTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.conversations_screen,
                    arguments: {'currentUserId': _currentUserId ?? ''},
                  ),
                );
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.lightprimery.withOpacity(0.3),
                // borderRadius: BorderRadius.circular(0.r),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primery,
                  // borderRadius: BorderRadius.circular(12.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle:
                AppStyle.boldBackground.copyWith(fontSize: 14.sp),
                unselectedLabelStyle:
                AppStyle.boldPrimery.copyWith(fontSize: 14.sp),
                tabs: const [
                  Tab(text: 'My Posts'),
                  Tab(text: 'Active Orders'),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PostsTab(
                    onBidsLoaded: (bids) {
                      if (mounted) setState(() => _allBids = bids);
                    },
                  ),
                  ActiveOrdersTab(bids: _allBids),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'customer',
        selectedIndex: 3,
      ),
    );
  }
}
