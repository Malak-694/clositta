import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/router/route_names.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
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

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  final prefs = getIt<SharedPrefHelper>();
  String? _currentUserId;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserId();

    _tabController.addListener(() {
      if (_tabController.index == 1) {
        context.read<CustomerBiddingCubit>().loadAcceptedOffers();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerBiddingCubit>().getMyBids();
    });
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
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primery,
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
                  const PostsTab(),
                  const ActiveOrdersTab(),
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