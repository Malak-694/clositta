import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 200.h),
          Icon(
            Icons.shopping_bag_outlined,
            size: 54.sp,
            color: AppColors.light,
          ),
          SizedBox(height: 12.h),
          Center(
            child: Text(
              'No orders yet',
              style: AppStyle.medBlack.copyWith(fontSize: 18.sp),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: Text(
              'Place your first order and it will appear here.',
              style: AppStyle.smallBlack.copyWith(color: AppColors.light),
            ),
          ),
        ],
      ),
    );
  }
}
