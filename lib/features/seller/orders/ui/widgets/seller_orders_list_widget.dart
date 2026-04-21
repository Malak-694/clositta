import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/seller/orders/data/models/order_seller_response_model.dart';
import 'package:chicora/features/seller/orders/ui/widgets/seller_order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SellerOrdersListWidget extends StatelessWidget {
  const SellerOrdersListWidget({
    super.key,
    required this.orders,
    required this.onRefresh,
    required this.onUpdateStatus,
  });

  final List<OrderSellerResponseModel> orders;
  final Future<void> Function() onRefresh;
  final Future<void> Function(
    OrderSellerResponseModel order, {
    String? orderStatus,
    String? paymentStatus,
  }) onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No orders yet',
                style: AppStyle.medBlack.copyWith(fontSize: 16.sp),
              ),
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return SellerOrderCardWidget(
            order: order,
            onUpdateStatus: ({
              String? orderStatus,
              String? paymentStatus,
            }) =>
                onUpdateStatus(
                  order,
                  orderStatus: orderStatus,
                  paymentStatus: paymentStatus,
                ),
          );
        },
      ),
    );
  }
}
