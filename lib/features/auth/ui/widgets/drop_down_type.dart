import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double width;
  final TextStyle? style;
  final Color? color;
  final double? vPadding;
  const CustomDropdown({
    super.key,
    this.value = "Customer",
    this.hintText = "Type",
    required this.items,
    required this.onChanged,
    this.width = 350,
    this.style,
    this.color,
    this.vPadding,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? AppStyle.medPrimery;
    final hintStyle = style ?? AppStyle.medBlack;

    return SizedBox(
      width: width.w,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: value,
        hint: Text(
          hintText,
          style: hintStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        selectedItemBuilder: (context) {
          return items.map((String item) {
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
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: color ?? AppColors.lightprimery,
        borderRadius: BorderRadius.circular(25.r),
        decoration: InputDecoration(
          filled: true,
          fillColor: color ?? AppColors.lightprimery,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: vPadding ?? 18.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
