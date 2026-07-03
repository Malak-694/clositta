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
  final bool showAllOption; // adds a null "All" item, like Price Sort dropdown

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
    this.width,
    this.height,
    this.showAllOption = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? AppStyle.body3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(label!, style: AppStyle.body3),
              if (required) ...[
                SizedBox(width: 4.w),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
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
            initialValue: value,
            isExpanded: isExpanded,
            isDense: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primery,
              size: 20.sp,
            ),
            hint: Text(
              hintText,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            selectedItemBuilder: (context) {
              final allItems = [if (showAllOption) 'All', ...items];
              return allItems.map((item) {
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
            items: [
              if (showAllOption)
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('All', style: textStyle),
                ),
              ...items.map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            onChanged: enabled ? onChanged : null,
            dropdownColor: fillColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: value != null
                  ? AppColors.primery.withValues(alpha: 0.1)
                  : fillColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: vPadding ?? 12.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Colors.grey[300]!.withOpacity(0.5),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.red[400]!, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.red[600]!, width: 2),
              ),
              isDense: true,
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
