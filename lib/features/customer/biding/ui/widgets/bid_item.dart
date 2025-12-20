import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/customer/biding/ui/widgets/cutsom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BidItem extends StatelessWidget {
  final String tailor;
  final int price;
  final int num_work;
  final int duration;
  final String? comment;

  const BidItem({
    super.key,
    required this.tailor,
    required this.duration,
    required this.price,
    required this.num_work,
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
                Text(tailor, style: AppStyle.headline2),
                Text('\$$price', style: AppStyle.body1),
              ],
            ),
            // SizedBox(height: .h),
            Row(
              children: [
                Icon(LucideIcons.smile, size: 20, color: AppColors.light),
                const SizedBox(width: 2),
                Text(' $num_work Tailor', style: AppStyle.body5),
                const Spacer(),
                Icon(LucideIcons.clock, size: 18, color: AppColors.light),
                const SizedBox(width: 1),
                Text(' ${duration}d', style: AppStyle.body5),
              ],
            ),
            const SizedBox(height: 10),
            if (comment != null) Text(comment!, style: AppStyle.body6),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: "chat",
                  onPressed: () {},
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.light,
                  icon: LucideIcons.messageCircle,
                ),
                CustomButton(
                  text: "Select",
                  onPressed: () {},
                  backgroundColor: AppColors.primery,
                  foregroundColor: AppColors.background,
                  icon: LucideIcons.userRoundCheck,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
