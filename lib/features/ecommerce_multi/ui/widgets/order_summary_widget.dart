import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class OrderSummary extends StatelessWidget {
  const OrderSummary({
    super.key,
    required this.subtotal,
    this.shippingCost = 0.0,
  });

  final double subtotal;
  final double shippingCost;

  @override
  Widget build(BuildContext context) {
    final total = subtotal + shippingCost;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
            labelStyle: AppStyle.medPrimery.copyWith(fontSize: 14.sp),
            valueStyle: AppStyle.medBlack.copyWith(fontSize: 14.sp),
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Shipping',
            value: shippingCost == 0
                ? 'Free'
                : '\$${shippingCost.toStringAsFixed(2)}',
            labelStyle: AppStyle.medPrimery.copyWith(fontSize: 14.sp),
            valueStyle: AppStyle.medBlack.copyWith(fontSize: 14.sp),
          ),
          const Divider(height: 20, thickness: 0.8),
          _SummaryRow(
            label: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            labelStyle: AppStyle.medBlack.copyWith(fontSize: 16.sp),
            valueStyle: AppStyle.medPrimery.copyWith(fontSize: 20.sp),
          ),
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
