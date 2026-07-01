import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chicora/core/constants/colors.dart';
import '../../data/models/daily_outfit_response_model.dart';

class OutfitCard extends StatelessWidget {
  final String title;
  final List<OutfitItemModel> items;
  final List<String> categories;


  final void Function(OutfitItemModel item, String category)? onItemTap;

  const OutfitCard({
    super.key,
    required this.title,
    required this.items,
    required this.categories,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.light, width: 0.2),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, i) {
              final item = items[i];
              final category = categories[i];
              return Container(
                padding: EdgeInsetsDirectional.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.lightprimery,
                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: AppColors.light, width: 0.7),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.light, // shadow color
                      spreadRadius: 2,                       // how much the shadow spreads
                      blurRadius: 4,                         // how blurry the edges are
                      offset: Offset(0, 4),                  // horizontal, vertical shift
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onItemTap == null
                            ? null
                            : () => onItemTap!(item, category),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.imagekitUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.light),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.displayLabel(category),
                      style: TextStyle(fontSize: 13.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}