import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/style.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_category_selector.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import '../../../../chat/logic/conversations_cubit/conversations_cubit.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import '../../../../notifications/data/models/unread_count_response.dart';
import '../../../../notifications/logic/cubit/notification_cubit.dart';
import '../../data/models/accepted_offer_model.dart';

class ActiveOrderScreen extends StatelessWidget {
  const ActiveOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BiddingTailorCubit>()..getMyAcceptedOffers(),
      child: const _ActiveOrderView(),
    );
  }
}

class _ActiveOrderView extends StatefulWidget {
  const _ActiveOrderView();

  @override
  State<_ActiveOrderView> createState() => _ActiveOrderViewState();
}

class _ActiveOrderViewState extends State<_ActiveOrderView> {
  List<AcceptedOfferResponse> _orders = [];
  bool _isLoading = false;
  String _selectedFilter = 'all';

  final Map<String, String> _filterLabels = {
    'all': 'All',
    'accepted': 'Accepted',
    'in_progress': 'In Progress',
    'completed': 'Completed',
  };

  final prefs = getIt<SharedPrefHelper>();

  String _statusLabel(String? s) {
    switch (s) {
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Accepted';
    }
  }

  List<String> getNextStatuses(String? status) {
    switch (status) {
      case 'accepted':
        return ['accepted', 'in_progress'];
      case 'in_progress':
        return ['in_progress', 'completed'];
      case 'completed':
        return ['completed'];
      default:
        return ['accepted', 'in_progress', 'completed'];
    }
  }

  List<AcceptedOfferResponse> get _filteredOrders {
    if (_selectedFilter == 'all') return _orders;
    return _orders.where((o) {
      final status = o.workStatus ?? 'accepted';
      return status == _selectedFilter;
    }).toList();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _refresh() async {
    context.read<BiddingTailorCubit>().refreshAcceptedOffers();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = cartTotalItemQuantity(context.watch<CartCubit>().state);
    final chatCount = context.watch<ConversationsCubit>().unreadCount;
    final notifCount = context.watch<NotificationCubit>().state.maybeWhen(
      success: (data) => data is UnreadCountResponse ? data.unreadCount : 0,
      orElse: () => 0,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Active Orders',
        showCartIcon: true,
        cartItemCount: cartCount,
        onCartTap: () =>
            Navigator.pushNamed(context, RouteNames.customer_cart_screen),
        showNotificationIcon: true,
        unreadNotificationCount: notifCount,
        onNotificationTap: () =>
            Navigator.pushNamed(context, RouteNames.notification_screen),
        showChatIcon: true,
        unreadChatCount: chatCount,
        onChatTap: () async {
          final userId = await prefs.getSecureData('id') ?? '';
          Navigator.pushNamed(
            context,
            RouteNames.conversations_screen,
            arguments: {'currentUserId': userId ?? ''},
          );
        },
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocListener<BiddingTailorCubit, BiddingTailorState>(
        listener: (context, state) {
          state.when(
            initial: () {
              setState(() => _isLoading = true);
            },
            loading: () {
              setState(() => _isLoading = true);
            },
            fail: (err) {
              setState(() => _isLoading = false);
              _showErrorSnackBar(err);
            },
            success: (data) {
              if (data is List<AcceptedOfferResponse>) {
                setState(() {
                  _orders = data;
                  _isLoading = false;
                });
              } else {
                // For non-list success responses (e.g. after updateWorkStatus
                // confirmation), just clear loading — the cubit will follow
                // up with a refresh that emits a new List<AcceptedOfferResponse>.
                setState(() => _isLoading = false);
              }
            },
          );
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomCategorySelector(
                  categories: _filterLabels.values.toList(),
                  selectedCategory: _filterLabels[_selectedFilter] ?? 'All',
                  onCategorySelected: (label) {
                    final key = _filterLabels.entries
                        .firstWhere((e) => e.value == label)
                        .key;
                    setState(() => _selectedFilter = key);
                  },
                  selectedColor: AppColors.secondary,
                  unselectedColor: AppColors.lightsecondary,
                  selectedTextColor: AppColors.background,
                  unselectedTextColor: AppColors.darkPrimary,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavBar(userRole: 'tailor', selectedIndex: 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
            context, RouteNames.generate_image_tailor_screen),
        child: const Icon(Icons.auto_awesome),
      ),
    );
  }

  Widget _buildBody() {
    // Show a full-screen spinner on first load (list is still empty).
    if (_isLoading && _orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: AppColors.primery,
      child: _buildList(),
    );
  }

  Widget _buildList() {
    if (_orders.isEmpty) {
      // Not loading and truly no orders — show empty state.
      return ListView(
        // Wrap in ListView so RefreshIndicator still works on an empty screen.
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inbox_outlined,
                    size: 64.sp, color: AppColors.lightsecondary),
                SizedBox(height: 12.h),
                Text('No active orders yet', style: AppStyle.medLight),
              ],
            ),
          ),
        ],
      );
    }

    if (_filteredOrders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          Center(
            child: Text(
              'No orders with status "${_statusLabel(_selectedFilter)}"',
              style: AppStyle.medLight,
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          itemCount: _filteredOrders.length,
          itemBuilder: (context, index) {
            final order = _filteredOrders[index];
            final dropdownItems = getNextStatuses(order.workStatus);
            return Card(
              color: Theme.of(context).scaffoldBackgroundColor,
              margin: EdgeInsets.only(bottom: 12.h),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            order.bid.requestDescription,
                            style: AppStyle.medBlack,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: _statusColor(order.workStatus),
                          ),
                          child: Text(
                            _statusLabel(order.workStatus),
                            style: AppStyle.smallBackground,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'for ${order.bid.customer.name}',
                      style: AppStyle.medPrimery.copyWith(fontSize: 17.sp),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deadline',
                              style:
                                  AppStyle.medPrimery.copyWith(fontSize: 17.sp),
                            ),
                            Text(
                              order.isOverdue == true
                                  ? 'Overdue!'
                                  : '${order.daysRemaining ?? order.timeInDays} days',
                              style: order.isOverdue == true
                                  ? AppStyle.body5
                                      .copyWith(color: Colors.red)
                                  : AppStyle.body5,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Payment',
                              style:
                                  AppStyle.medPrimery.copyWith(fontSize: 17.sp),
                            ),
                            Text('\$${order.price}', style: AppStyle.body5),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomDropdownList(
                            fillColor: AppColors.background,
                            label: "Status",
                            value: order.workStatus ?? 'accepted',
                            items: dropdownItems,
                            hintText: "",
                            onChanged: (newStatus) {
                              if (newStatus == null ||
                                  newStatus == order.workStatus) {
                                return;
                              }
                              context
                                  .read<BiddingTailorCubit>()
                                  .updateWorkStatus(order.id, newStatus);
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.chat_screen,
                              arguments: {
                                'receiverId': order.bid.customer.id,
                                'receiverName': order.bid.customer.name,
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            padding: EdgeInsets.all(13.w),
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: AppColors.primery,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Theme.of(context).cardColor,
                              size: 22.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Subtle top-of-list loading bar when refreshing existing data.
        if (_isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      default:
        return AppColors.primery;
    }
  }
}
