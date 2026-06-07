import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeasurementField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String unit;
  final bool isLast;

  const MeasurementField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.unit,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      controller: controller,
      label: label,
      hintText: hint,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: isLast ? (_) => FocusScope.of(context).unfocus() : null,
      textStyle: AppStyle.smallBlack.copyWith(fontSize: 14.sp),
      filled: true,
      fillColor: AppColors.lightprimery,
      borderColor: AppColors.lightprimery,
      focusedBorderColor: AppColors.primery,
      labelStyle: AppStyle.smallBlack.copyWith(fontSize: 14.sp),

      suffixIcon: Padding(
        padding: EdgeInsets.only(top: 12.h, right: 12.w),
        child: Text(
          unit,
          style: AppStyle.smallPrimery.copyWith(fontSize: 13.sp),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        final parsed = double.tryParse(value.trim());
        if (parsed == null || parsed <= 0) {
          return 'Enter a valid number';
        }
        return null;
      },
    );
  }
}
