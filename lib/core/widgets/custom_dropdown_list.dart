


import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownList extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final String hintText;
  final void Function(String?) onChanged;
  final bool required;
  final bool enabled;
  final Color fillColor  ;

  // final double? height ;
  // final double? width;

  CustomDropdownList({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.fillColor = AppColors.lightprimery,
    this.required = false,
    this.enabled = true,
    // this.width = double.infinity ,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(label, style: AppStyle.body6),
            if (required) ...[
              SizedBox(width: 4.w),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
            ],
          ],
        ),
        SizedBox(height: 8.h),


        // Dropdown
        DropdownButtonFormField(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: fillColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.light),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.light),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
          ),
          validator: required ? (value) {
            if (value == null) return 'This field is required';
            return null;
          } : null,
        ),
      ],
    );
  }
}
