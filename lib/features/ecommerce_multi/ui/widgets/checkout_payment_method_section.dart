import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutPaymentMethodSection extends StatelessWidget {
  const CheckoutPaymentMethodSection({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
    required this.rolePrimary,
    required this.roleDark,
  });

  final String selectedMethod;
  final ValueChanged<String> onMethodSelected;
  final Color rolePrimary;
  final Color roleDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment method',
          style: AppStyle.medBlack.copyWith(fontSize: 20.sp),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: rolePrimary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: rolePrimary.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _CheckoutPaymentOptionTile(
                value: OrderRequestModel.paymentCredit,
                title: 'Credit card',
                subtitle: 'Pay online with your card',
                selectedMethod: selectedMethod,
                rolePrimary: rolePrimary,
                roleDark: roleDark,
                onSelected: onMethodSelected,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: rolePrimary.withOpacity(0.12),
              ),
              _CheckoutPaymentOptionTile(
                value: OrderRequestModel.paymentCashOnDelivery,
                title: 'Cash on delivery',
                subtitle: 'Pay when you receive your order',
                selectedMethod: selectedMethod,
                rolePrimary: rolePrimary,
                roleDark: roleDark,
                onSelected: onMethodSelected,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckoutPaymentOptionTile extends StatelessWidget {
  const _CheckoutPaymentOptionTile({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.selectedMethod,
    required this.rolePrimary,
    required this.roleDark,
    required this.onSelected,
  });

  final String value;
  final String title;
  final String subtitle;
  final String selectedMethod;
  final Color rolePrimary;
  final Color roleDark;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = selectedMethod == value;
    final subtitleStyle =
        AppStyle.body6.copyWith(color: roleDark.withOpacity(0.72));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelected(value),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: selected ? rolePrimary : roleDark.withOpacity(0.45),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppStyle.smallBlack),
                    SizedBox(height: 2.h),
                    Text(subtitle, style: subtitleStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
