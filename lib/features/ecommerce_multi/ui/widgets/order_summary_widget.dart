import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({
    super.key,
    required this.subtotal,
    this.shippingCost = 0.0,
    this.shippingValueText,
    this.subOrders,
    this.backgroundColor = const Color(0xFFF0EFFF),
    this.accentColor = AppColors.primery,
  });

  final double subtotal;
  final double shippingCost;
  final String? shippingValueText;
  final List<SubOrderModel>? subOrders;
  final Color backgroundColor;
  final Color accentColor;

  List<MapEntry<String, List<SubOrderModel>>> _groupSubOrdersBySeller() {
    final source = subOrders ?? const <SubOrderModel>[];
    final grouped = <String, List<SubOrderModel>>{};

    for (final subOrder in source) {
      final sellerName = subOrder.seller?.name;
      final sellerId = subOrder.seller?.id;
      final key = (sellerName != null && sellerName.trim().isNotEmpty)
          ? sellerName.trim()
          : (sellerId != null && sellerId.trim().isNotEmpty)
          ? 'Seller #${sellerId.substring(0, sellerId.length > 6 ? 6 : sellerId.length)}'
          : 'Unknown Seller';
      grouped.putIfAbsent(key, () => <SubOrderModel>[]).add(subOrder);
    }

    return grouped.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    final total = subtotal + shippingCost;
    final groupedSubOrders = _groupSubOrdersBySeller();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
            labelStyle: AppStyle.medPrimery.copyWith(
              fontSize: 14.sp,
              color: accentColor,
            ),
            valueStyle: AppStyle.medBlack.copyWith(fontSize: 14.sp),
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Shipping',
            value:
                shippingValueText ??
                (shippingCost == 0
                    ? 'Free'
                    : '\$${shippingCost.toStringAsFixed(2)}'),
            labelStyle: AppStyle.medPrimery.copyWith(
              fontSize: 14.sp,
              color: accentColor,
            ),
            valueStyle: AppStyle.medBlack.copyWith(fontSize: 14.sp),
          ),
          const Divider(height: 20, thickness: 0.8),
          _SummaryRow(
            label: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            labelStyle: AppStyle.medBlack.copyWith(fontSize: 16.sp),
            valueStyle: AppStyle.medPrimery.copyWith(
              fontSize: 20.sp,
              color: accentColor,
            ),
          ),
          if (groupedSubOrders.isNotEmpty) ...[
            const Divider(height: 20, thickness: 0.8),
            ...groupedSubOrders.map(
              (sellerGroup) => _SellerSubOrdersSection(
                sellerName: sellerGroup.key,
                subOrders: sellerGroup.value,
                accentColor: accentColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SellerSubOrdersSection extends StatelessWidget {
  Color _orderStatusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('confirmed') || s.contains('refunded')) {
      return Colors.green;
    }
    if (s.contains('cancelled')) {
      return AppColors.ternary;
    }
    return AppColors.secondary;
  }

  const _SellerSubOrdersSection({
    required this.sellerName,
    required this.subOrders,
    required this.accentColor,
  });

  final String sellerName;
  final List<SubOrderModel> subOrders;
  final Color accentColor;

  String _displayStatus(String? status) {
    if (status == null || status.trim().isEmpty) return 'Pending';
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sellerName, style: AppStyle.medBlack.copyWith(fontSize: 14.sp)),
          SizedBox(height: 6.h),
          ...subOrders.asMap().entries.map((entry) {
            final index = entry.key;
            final subOrder = entry.value;
            final status = _displayStatus(subOrder.orderStatus);
            final amount = (subOrder.subTotal ?? subOrder.itemsTotal ?? 0)
                .toString();
            return Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Suborder ${index + 1}:  ',
                          style: AppStyle.smallBlack,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: _orderStatusColor(
                              status,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            status,
                            style: AppStyle.smallBlack.copyWith(
                              color: _orderStatusColor(status),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$amount EGP',
                    style: AppStyle.smallPrimery.copyWith(color: accentColor),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}
