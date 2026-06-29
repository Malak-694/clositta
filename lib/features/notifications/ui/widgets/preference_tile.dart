


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';

class PreferenceTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isFirst;
  final bool isLast;

  const PreferenceTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
    this.isFirst = false,
    this.isLast  = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top:    isFirst ? Radius.circular(16.r) : Radius.zero,
        bottom: isLast  ? Radius.circular(16.r) : Radius.zero,
      ),
      child: SwitchListTile.adaptive(
        contentPadding:
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        secondary: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        title: Text(title, style: AppStyle.body6),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Text(subtitle,
              style: AppStyle.body5.copyWith(fontSize: 14)),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primery,
        inactiveTrackColor: AppColors.lightprimery,
      ),
    );
  }
}