import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMediumButton extends StatelessWidget {
  const CustomMediumButton({
    super.key,
    required this.value,
    required this.onPressed,
    required this.isLoading,
    required this.color,
    this.width = 220,
  });

  final value;
  final VoidCallback? onPressed;
  final Color color;
  final double width;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? (){} : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primery,
        minimumSize: Size(width.w, 55.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: AppColors.primery,
              ),
            )
          : Text(value, style: AppStyle.button),
    );
  }
}
