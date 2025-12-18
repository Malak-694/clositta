import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chicora/core/constants/colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isSelected;

  const StatusBadge({
    super.key,
    required this.status,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 65.w,
      margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.sp),
        color: isSelected ? AppColors.light : Colors.greenAccent,
        border: Border.all(color: isSelected ? AppColors.dark : Colors.green),
      ),
      child: Center(
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? AppColors.dark : Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
