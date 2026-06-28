import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/seller/orders/ui/widgets/seller_order_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SellerOrderStatusFilterBar extends StatelessWidget {
  const SellerOrderStatusFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  /// `null` means “all orders”.
  final String? selectedStatus;
  final ValueChanged<String?> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final filters = <({String? value, String label})>[
      (value: null, label: 'All'),
      ...kSellerOrderStatusValues.map(
        (v) => (value: v, label: sellerOrderStatusLabel(v)),
      ),
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = filters[index];
          final selected = item.value == selectedStatus;
          return FilterChip(
            label: Text(
              item.label,
              style: AppStyle.body6.copyWith(
                fontSize: 12.sp,
                color: selected ? Colors.white : AppColors.primery,
              ),
            ),
            selected: selected,
            showCheckmark: false,
            selectedColor: AppColors.ternary,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: selected ? AppColors.ternary : Colors.grey.shade300,
            ),
            onSelected: (_) => onStatusSelected(item.value),
          );
        },
      ),
    );
  }
}
