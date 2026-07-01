


import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownList extends StatelessWidget {
  final String? label;
  final String? value;
  final List<String> items;
  final String hintText;
  final void Function(String?) onChanged;
  final bool required;
  final bool enabled;
  final Color fillColor;
  final TextStyle? style;
  final double? vPadding;
  final bool isExpanded;
  final double? width;
  final double? height;

  const CustomDropdownList({
    super.key,
    this.label,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.fillColor = AppColors.lightprimery,
    this.required = false,
    this.enabled = true,
    this.style,
    this.vPadding,
    this.isExpanded = true,
    this.width ,
    this.height ,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? AppStyle.body3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label

        if(label != null) ...[Row(
          children: [
            Text(label!, style: AppStyle.body3),
            if (required) ...[
              SizedBox(width: 4.w),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
            ],
          ],
        ),
        SizedBox(height: 8.h),
  ],

        // Dropdown
        SizedBox(
          width: width?.w ?? double.infinity,
          height: height?.h,
          child: DropdownButtonFormField<String>(
            isExpanded: isExpanded,
            initialValue: value??items.first,
            hint: Text(
              hintText,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            selectedItemBuilder: (context) {
              return items.map((item) {
                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    item,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: enabled ? onChanged : null,
            dropdownColor: fillColor,
            decoration: InputDecoration(
              hintText: hintText,
              fillColor: fillColor,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: vPadding ?? 12.h,
              ),
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
            validator: required
                ? (value) {
              if (value == null) return 'This field is required';
              return null;
            }
                : null,
          ),
        ),
      ],
    );
  }
}