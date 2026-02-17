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

  const CustomDropdown({
    super.key,
    this.value = "Customer",
    this.hintText = "Type",
    required this.items,
    required this.onChanged,
    this.width = 350,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        hint: Text(hintText, style: AppStyle.medBlack),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: AppStyle.medPrimery),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: AppColors.lightprimery,
        borderRadius: BorderRadius.circular(25.r),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.lightprimery,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 18.h,
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
