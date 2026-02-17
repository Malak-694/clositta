import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BidItemTailor extends StatelessWidget {
  final String tailorName;
  final int price;
  final int duration;
  final String? comment;

  const BidItemTailor({
    super.key,
    required this.tailorName,
    required this.duration,
    required this.price,
    this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 150.w,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: ShapeDecoration(
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.light,
            blurRadius: 5,
            offset: Offset(0, .5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tailorName, style: AppStyle.boldSecondary),
                Text('\$$price', style: AppStyle.medBlack),
              ],
            ),
            // SizedBox(height: .h),
            Row(
              children: [
                // Icon(LucideIcons.smile, size: 20, color: AppColors.light),
                // const SizedBox(width: 2),
                // Text(' $num_work Tailor', style: AppStyle.body5),
                const Spacer(),
                Icon(LucideIcons.clock, size: 18, color: AppColors.light),
                const SizedBox(width: 1),
                Text(' ${duration}d', style: AppStyle.body5),
              ],
            ),
            const SizedBox(height: 10),
            if (comment != null) Text(comment!, style: AppStyle.body6),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
