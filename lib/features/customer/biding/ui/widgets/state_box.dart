

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/style.dart';

class StateBox extends StatelessWidget {
  const StateBox({super.key, required this.label, required this.value});
  final String label ;
  final String value ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.lightprimery.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyle.body5.copyWith(fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppStyle.smallPrimery.copyWith(fontSize: 13.sp),
          ),
        ],
      ),
    );;
  }
}
