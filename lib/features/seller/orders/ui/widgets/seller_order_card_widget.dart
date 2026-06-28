import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/seller/orders/data/models/order_seller_response_model.dart';
import 'package:chicora/features/seller/orders/ui/widgets/seller_order_ui_constants.dart';
import 'package:chicora/features/seller/orders/ui/widgets/seller_order_update_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color _orderStatusColor(String? status) {
  switch (status) {
    case 'delivered':
      return Colors.green;
    case 'shipped':
      return Colors.blue;
    case 'confirmed':
      return Colors.teal;
    case 'placed':
      return Colors.orange;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String _formatMoney(int? amount) {
  if (amount == null) return '—';
  return '£$amount';
}

String _formatDate(String? iso) {
  if (iso == null || iso.isEmpty) return '—';
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return iso;
  return '${parsed.day}/${parsed.month}/${parsed.year}';
}

class SellerOrderCardWidget extends StatelessWidget {
  const SellerOrderCardWidget({
    super.key,
    required this.order,
    required this.onUpdateStatus,
  });

  final OrderSellerResponseModel order;
  final Future<void> Function({String? orderStatus}) onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    final orderStatus = order.resolvedOrderStatus ?? '';
    final paymentStatus = order.paymentStatus ?? '';
    final paymentMethod = order.paymentMethod == 'cash_on_delivery'
        ? 'Cash on delivery'
        : order.paymentMethod;
    final paymentSummary = [
      if (paymentMethod != null) sellerOrderStatusLabel(paymentMethod),
      if (paymentStatus.isNotEmpty)
        'Pay: ${sellerOrderStatusLabel(paymentStatus)}',
    ].join(' · ');
    final statusColor = _orderStatusColor(order.resolvedOrderStatus);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.resolvedCustomer?.name ?? 'Customer',
                    style: AppStyle.medBlack.copyWith(fontSize: 15.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    orderStatus.isEmpty
                        ? '—'
                        : sellerOrderStatusLabel(orderStatus),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              _formatDate(order.createdAt),
              style: AppStyle.body6.copyWith(
                fontSize: 12.sp,
                color: AppColors.primery,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  'Total: ${_formatMoney(order.resolvedTotalAmount)}',
                  style: AppStyle.medPrimery.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.ternary,
                  ),
                ),
                if (paymentSummary.isNotEmpty) ...[
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      paymentSummary,
                      style: AppStyle.smallBlack,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        children: [
          if (order.shippingAddress != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Shipping',
                style: AppStyle.medPrimery.copyWith(fontSize: 13.sp),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              [
                order.shippingAddress!.fullName,
                order.shippingAddress!.phone,
                order.shippingAddress!.address,
                [
                  order.shippingAddress!.city,
                  order.shippingAddress!.governorate,
                ].whereType<String>().where((s) => s.isNotEmpty).join(', '),
              ].whereType<String>().where((s) => s.isNotEmpty).join('\n'),
              style: AppStyle.body6.copyWith(fontSize: 12.sp),
            ),
            SizedBox(height: 12.h),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Items (${order.resolvedItems?.length ?? 0})',
              style: AppStyle.medPrimery.copyWith(fontSize: 13.sp),
            ),
          ),
          SizedBox(height: 8.h),
          ...?order.resolvedItems?.map((item) {
            final name = item.product?.name ?? item.name ?? 'Item';
            final qty = item.quantity ?? 0;
            final line = item.subtotal ?? item.price;
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      item.imageUrl ?? item.product?.imageUrl ?? '',
                      width: 48.w,
                      height: 48.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 48.w,
                        height: 48.h,
                        color: Colors.grey.shade200,
                        child: Icon(Icons.image_not_supported, size: 20.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppStyle.medBlack.copyWith(fontSize: 13.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Qty $qty · ${_formatMoney(line)}',
                          style: AppStyle.smallBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showSellerOrderUpdateBottomSheet(
                  context: context,
                  order: order,
                  onSubmit: onUpdateStatus,
                );
              },
              icon: Icon(
                Icons.edit_outlined,
                size: 18.sp,
                color: AppColors.ternary,
              ),
              label: Text(
                'Update status',
                style: AppStyle.medTernary.copyWith(fontSize: 14.sp),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.ternary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
