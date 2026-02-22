import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/style.dart';

class CustomCategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final Color selectedColor;
  final Color unselectedColor;

  const CustomCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < categories.length; i++) ...[
            ElevatedButton(
              onPressed: () => onCategorySelected(categories[i]),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 30),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: selectedCategory == categories[i]
                    ? selectedColor
                    : unselectedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                categories[i],
                style: AppStyle.smallBackground,
              ),
            ),
            if (i != categories.length - 1) SizedBox(width: 5.w),
          ],
        ],
      ),
    );
  }
}