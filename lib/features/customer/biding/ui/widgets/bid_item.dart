import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/customer/biding/ui/widgets/cutsom_button.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BidItem extends StatelessWidget {
  final String offerId;
  final String tailor;
  final String tailorId;
  final String? email ;
  final String? tailorImage;
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
    required this.tailorId,
    this.tailorImage,
    this.email,// ← NEW
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
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.primery,
            blurRadius: 4,
            offset: const Offset(0, .5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tailor Info Row ─────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.tailor_info_screen,
                    arguments: {
                      'name': tailor,
                      'imageUrl': tailorImage,
                      'tailorId': tailorId,
                      'email' : email ,
                      'products': <Map<String, dynamic>>[],
                    },
                  );
                },
                child: Row(
                  children: [
                    // ── Avatar ──────────────────────────────
                    CircleAvatar(
                      radius: 18.sp,
                      backgroundColor: AppColors.lightprimery,
                      backgroundImage:
                      (tailorImage != null && tailorImage!.isNotEmpty)
                          ? NetworkImage(tailorImage!)
                          : null,
                      child: (tailorImage == null || tailorImage!.isEmpty)
                          ? Icon(
                        Icons.person,
                        size: 18.sp,
                        color: AppColors.primery,
                      )
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    Text(tailor, style: AppStyle.boldSecondary),
                  ],
                ),
              ),
              Text('\$$price', style: AppStyle.medBlack),
            ],
          ),

          SizedBox(height: 8.h),

          // ── Stats Row ──────────────────────────────────────
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

          // ── Action Buttons ─────────────────────────────────
          Row(
            mainAxisAlignment: showSelectButton
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "chat",
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.chat_screen,
                    arguments: {
                      'receiverId': tailorId,
                      'receiverName': tailor,
                    },
                  );
                },
                backgroundColor: AppColors.primery,
                foregroundColor: AppColors.background,
                icon: LucideIcons.messageCircle,
              ),
              if (showSelectButton)
                CustomButton(
                  text: "Select",
                  onPressed: onAccept ?? () {},
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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