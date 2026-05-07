import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_response_model.dart';
import 'package:chicora/features/ecommerce_multi/ui/widgets/order_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsBottomSheet extends StatelessWidget {
  const OrderDetailsBottomSheet({
    super.key,
    required this.order,
    required this.subtotal,
    required this.shippingCost,
    required this.items,
    required this.canCancel,
    required this.onCancelOrder,
    required this.onItemTap,
  });

  final OrderDataModel order;
  final double subtotal;
  final double shippingCost;
  final List<OrderItemModel> items;
  final bool canCancel;
  final VoidCallback onCancelOrder;
  final ValueChanged<OrderItemModel> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'Order Details',
              style: AppStyle.medBlack.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 10.h),
            OrderDetailLine(label: 'Order ID', value: order.id ?? '-'),
            OrderDetailLine(
              label: 'Payment',
              value: order.paymentStatus ?? '-',
            ),
            OrderDetailLine(
              label: 'Total',
              value: '${order.totalAmount ?? 0} EGP',
            ),
            SizedBox(height: 10.h),
            OrderSummary(
              subtotal: subtotal,
              shippingCost: shippingCost,
              subOrders: order.subOrders,
              backgroundColor: AppColors.primery.withValues(alpha: 0.08),
              accentColor: AppColors.darkprimery,
            ),
            SizedBox(height: 8.h),
            canCancel
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: onCancelOrder,
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: AppColors.ternary,
                      ),
                      label: Text(
                        'Cancel Order',
                        style: AppStyle.body6.copyWith(
                          color: AppColors.ternary,
                        ),
                      ),
                    ),
                  )
                : Text(
                    'Order cannot be cancelled',
                    style: AppStyle.body6.copyWith(
                      color: AppColors.lightsecondary,
                    ),
                  ),
            SizedBox(height: 10.h),
            Text('Items', style: AppStyle.medPrimery.copyWith(fontSize: 16.sp)),
            SizedBox(height: 8.h),
            ...items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: OrderItemTile(item: item, onTap: () => onItemTap(item)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({super.key, required this.item, required this.onTap});

  final OrderItemModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7FF),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lightprimery),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width: 56.w,
                height: 56.w,
                child: Image.network(
                  item.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.light,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? 'Item',
                    style: AppStyle.body6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Tap image to view details',
                    style: AppStyle.smallBlack.copyWith(color: AppColors.light),
                  ),
                ],
              ),
            ),
            Text('x${item.quantity ?? 1}', style: AppStyle.smallBlack),
            SizedBox(width: 8.w),
            Text('${item.subtotal ?? 0} EGP', style: AppStyle.smallPrimery),
          ],
        ),
      ),
    );
  }
}

class OrderDetailLine extends StatelessWidget {
  const OrderDetailLine({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              '$label:',
              style: AppStyle.smallBlack.copyWith(color: AppColors.light),
            ),
          ),
          Expanded(child: Text(value, style: AppStyle.body6)),
        ],
      ),
    );
  }
}
