import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutTextField extends StatelessWidget {
   CheckoutTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.requiredField = true,
    this.labelColor,
    this.fillColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.labelSize =13
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool requiredField;
  final Color? labelColor;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final double labelSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: () {},
        maxLines: maxLines,
        style: AppStyle.body6,
        validator: (value) {
          if (!requiredField) return null;
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: AppStyle.smallPrimery.copyWith(
            fontSize: labelSize.sp,
            color: labelColor ?? AppColors.primery,
          ),
          hintStyle: AppStyle.smallBlack.copyWith(color: AppColors.light),
          filled: true,
          fillColor: fillColor ?? const Color(0xFFF8F7FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: enabledBorderColor ?? AppColors.lightprimery,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: focusedBorderColor ?? AppColors.primery,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
