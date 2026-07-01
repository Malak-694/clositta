import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMultiCategorySelector extends StatelessWidget {
  final List<String> categories;
  final Set<String> selectedCategories;
  final ValueChanged<String> onCategoryToggled;
  final Color selectedColor;
  final Color unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const CustomMultiCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategories,
    required this.onCategoryToggled,
    required this.selectedColor,
    required this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });

  TextStyle _textStyle(Color color) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w800,
    fontFamily: 'Raleway',
    color: color,
  );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.w,
      runSpacing: 8.h,
      children: [
        for (final category in categories)
          ElevatedButton(
            onPressed: () => onCategoryToggled(category),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 30),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: selectedCategories.contains(category)
                  ? selectedColor
                  : unselectedColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              category,
              style: _textStyle(
                selectedCategories.contains(category)
                    ? (selectedTextColor ?? Colors.white)
                    : (unselectedTextColor ?? Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}