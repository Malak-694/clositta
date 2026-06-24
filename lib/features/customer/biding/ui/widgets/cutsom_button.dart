import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? iconUrl;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconUrl,
    required this.backgroundColor,
    required this.foregroundColor,
    this.width = 165,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    // If we have an icon, use ElevatedButton.icon
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: AppStyle.boldPrimery.copyWith(
            foreground: Paint()
              ..color = foregroundColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: backgroundColor == Colors.white
                ? BorderSide(width: 1, color: AppColors.light)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
