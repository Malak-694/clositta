import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/seller/orders/data/models/order_seller_response_model.dart';
import 'package:chicora/features/seller/orders/ui/widgets/seller_order_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showSellerOrderUpdateBottomSheet({
  required BuildContext context,
  required OrderSellerResponseModel order,
  required Future<void> Function({String? orderStatus}) onSubmit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (sheetContext) {
      return _SellerOrderUpdateSheet(order: order, onSubmit: onSubmit);
    },
  );
}

class _SellerOrderUpdateSheet extends StatefulWidget {
  const _SellerOrderUpdateSheet({required this.order, required this.onSubmit});

  final OrderSellerResponseModel order;
  final Future<void> Function({String? orderStatus}) onSubmit;

  @override
  State<_SellerOrderUpdateSheet> createState() =>
      _SellerOrderUpdateSheetState();
}

class _SellerOrderUpdateSheetState extends State<_SellerOrderUpdateSheet> {
  String? _orderStatus;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final payStatus = widget.order.paymentStatus ?? '';
    final payMethod = widget.order.paymentMethod ?? '';
    final paymentStatusText = payStatus.isEmpty
        ? '—'
        : sellerOrderStatusLabel(payStatus);
    final paymentMethodText = payMethod.isEmpty
        ? '—'
        : sellerOrderStatusLabel(payMethod);

    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: bottomInset + 16.h + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Update order',
            style: AppStyle.medBlack.copyWith(fontSize: 18.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.order.resolvedCustomer?.name ?? 'Customer',
            style: AppStyle.body6.copyWith(
              fontSize: 14.sp,
              color: AppColors.primery,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Order status',
            style: AppStyle.medPrimery.copyWith(fontSize: 14.sp),
          ),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            value: _orderStatus,
            hint: Text(
              'No change',
              style: AppStyle.smallBlack.copyWith(fontSize: 14.sp),
            ),
            items: kSellerOrderStatusValues
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: Text(sellerOrderStatusLabel(v)),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _orderStatus = v),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Payment (read-only)',
            style: AppStyle.medPrimery.copyWith(fontSize: 14.sp),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: $paymentStatusText',
                  style: AppStyle.smallBlack.copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Method: $paymentMethodText',
                  style: AppStyle.smallBlack.copyWith(fontSize: 14.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () async {
                if (_submitting) return;
                if (_orderStatus == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Select an order status to update'),
                    ),
                  );
                  return;
                }
                setState(() => _submitting = true);
                try {
                  await widget.onSubmit(orderStatus: _orderStatus);
                  if (context.mounted) Navigator.pop(context);
                } finally {
                  if (mounted) setState(() => _submitting = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ternary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                _submitting ? 'Saving…' : 'Save',
                style: AppStyle.button,
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
