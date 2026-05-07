import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCardWidget extends StatelessWidget {
  const OrderCardWidget({super.key, required this.order, this.onTap});

  final OrderDataModel order;
  final VoidCallback? onTap;

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      final parsed = DateTime.parse(date).toLocal();
      return '${parsed.day}/${parsed.month}/${parsed.year}';
    } catch (_) {
      return date;
    }
  }

  Color _paymentStatusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('paid') || s.contains('refunded')) {
      return Colors.green;
    }
    if (s.contains('failed')) {
      return AppColors.ternary;
    }
    return AppColors.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final subOrders = order.subOrders ?? const <SubOrderModel>[];
    final itemsCount = subOrders.fold<int>(
      0,
      (sum, subOrder) => sum + (subOrder.items?.length ?? 0),
    );
    final paymentStatus = order.paymentStatus;
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7FF),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.lightprimery),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id?.substring(0, 8) ?? '-'}',
                    style: AppStyle.medBlack.copyWith(fontSize: 16.sp),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _paymentStatusColor(
                      paymentStatus,
                    ).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    paymentStatus ?? 'pending',
                    style: AppStyle.smallBlack.copyWith(
                      color: _paymentStatusColor(paymentStatus),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '${order.totalAmount ?? 0} EGP',
              style: AppStyle.medPrimery.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  '$itemsCount items',
                  style: AppStyle.smallBlack.copyWith(color: AppColors.light),
                ),
                const Spacer(),
                Text(
                  _formatDate(order.createdAt),
                  style: AppStyle.smallBlack.copyWith(color: AppColors.light),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
