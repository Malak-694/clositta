import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/router/route_names.dart';
import '../../logic/cubit/custom_bidding_cubit/customer_bidding_cubit.dart';
import '../../logic/cubit/custom_bidding_cubit/customer_bidding_state.dart';

class ActiveOrdersTab extends StatefulWidget {
  final List<BidResponse> bids;

  const ActiveOrdersTab({super.key, required this.bids});

  @override
  State<ActiveOrdersTab> createState() => _ActiveOrdersTabState();
}

class _ActiveOrdersTabState extends State<ActiveOrdersTab> {
  List<BidResponse> get _activeOrders =>
      widget.bids.where((b) => b.status.toLowerCase() == 'closed').toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_activeOrders.isNotEmpty) {
        context
            .read<CustomerBiddingCubit>()
            .loadAcceptedOffers(_activeOrders);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ActiveOrdersTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // reload if bids list changed
    if (oldWidget.bids != widget.bids && _activeOrders.isNotEmpty) {
      context
          .read<CustomerBiddingCubit>()
          .loadAcceptedOffers(_activeOrders);
    }
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'in_progress':
        return const Color(0xFFFF9500);
      case 'completed':
        return Colors.green.shade400;
      default:
        return AppColors.primery;
    }
  }

  String _statusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Accepted';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bids.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_outlined,
                size: 48.sp, color: Colors.grey.shade400),
            SizedBox(height: 12.h),
            Text('No active orders yet', style: AppStyle.medLight),
          ],
        ),
      );
    }

    if (_activeOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 48.sp, color: Colors.grey.shade400),
            SizedBox(height: 12.h),
            Text('No closed orders yet', style: AppStyle.medLight),
          ],
        ),
      );
    }

    return BlocBuilder<CustomerBiddingCubit, CustomerBiddingState>(
      builder: (context, state) {
        final acceptedOffers =
            context.read<CustomerBiddingCubit>().acceptedOffers;

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: _activeOrders.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final bid = _activeOrders[index];
            final offer = acceptedOffers[bid.id];
            final tailorName = offer?.tailor?.name ?? 'Unknown Tailor';
            final workStatus = offer?.workStatus ?? 'accepted';
            final receiverId = offer?.tailor?.id;
            final canOpenChat =
                receiverId != null && receiverId.isNotEmpty;

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.lightprimery, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Title + subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bid.requestDescription ?? '',
                              style: AppStyle.medBlack,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              tailorName,   // 👈 customer name as subtitle
                              style: AppStyle.smallPrimery,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(workStatus),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _statusLabel(workStatus),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Raleway',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h,),
                  GestureDetector(
                    onTap: canOpenChat
                        ? () => Navigator.pushNamed(
                              context,
                              RouteNames.chat_screen,
                              arguments: {
                                'receiverId': receiverId,
                                'receiverName': offer?.tailor?.name ?? '',
                              },
                            )
                        : null,
                    child: Opacity(
                      opacity: canOpenChat ? 1.0 : 0.4,
                      child: Container(
                        width: double.infinity,
                        height: 40.h,
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.lightprimery,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: AppColors.primery,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

