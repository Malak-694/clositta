import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/customer/biding/ui/widgets/cutsom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BidItem extends StatelessWidget {
  final String offerId;
  final String tailor;
  final int price;
  final int num_work;
  final int duration;
  final String? comment;
  final bool showSelectButton;
  final VoidCallback? onAccept;
  const BidItem({
    super.key,
    required this.offerId,
    required this.tailor,
    required this.duration,
    required this.price,
    required this.num_work,
    this.comment,
    this.showSelectButton = true,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: ShapeDecoration(
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.primery,
            blurRadius: 4,
            offset: Offset(0, .5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tailor, style: AppStyle.boldSecondary),
              Text('\$$price', style: AppStyle.medBlack),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(LucideIcons.smile, size: 20, color: AppColors.light),
              const SizedBox(width: 2),
              Text(' $num_work Tailoring', style: AppStyle.body5),
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
            mainAxisAlignment: showSelectButton
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "chat",
                onPressed: (){
                  Navigator.pushNamed(context, "chat_screen" , arguments: {"personName" : tailor});
                },
                backgroundColor: AppColors.primery,
                foregroundColor: AppColors.background,
                icon: LucideIcons.messageCircle,
                // width: showSelectButton ? 112 : 130,
                // height: showSelectButton ? 39 : 47,
                              ),
              if (showSelectButton)
                CustomButton(
                  text: "Select",
                  onPressed: onAccept ?? () {}, // 👈
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.light,
                  icon: LucideIcons.userRoundCheck,
                ),
            ],
          ),
        ],
      ),
    );
  }
}