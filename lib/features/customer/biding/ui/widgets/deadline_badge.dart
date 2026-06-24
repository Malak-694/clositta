

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeadlineBadge extends StatelessWidget {
  const DeadlineBadge({super.key, required this.deadline});
  final DateTime deadline ;
  @override
  Widget build(BuildContext context) {
    final diff = deadline.difference(DateTime.now()).inDays;
    final isOverdue = diff < 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        isOverdue
            ? '${diff.abs()} day${diff.abs() == 1 ? '' : 's'} overdue'
            : '$diff day${diff == 1 ? '' : 's'} left',
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: isOverdue ? Colors.red.shade700 : Colors.green.shade700,
          fontFamily: 'Raleway',
        ),
      ),
    );
  }
}
