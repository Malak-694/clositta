import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/tailor/bidding_tailor/ui/widgets/custom_tailor_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BidItemTailor extends StatelessWidget {
  final String tailorName;
  final int? price;
  final int? duration;
  final String? comment;
  final bool isMyOffer;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BidItemTailor({
    super.key,
    required this.tailorName,
    required this.duration,
    required this.price,
    this.comment,
    this.isMyOffer = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            offset: const Offset(0, .5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name + Price ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tailorName, style: AppStyle.boldSecondary),
                Text('\$${price ?? '-'}', style: AppStyle.medBlack),
              ],
            ),

            // ── Duration ─────────────────────────────────────
            Row(
              children: [
                const Spacer(),
                Icon(LucideIcons.clock, size: 15, color: AppColors.light),
                const SizedBox(width: 1),
                Text(' ${duration ?? '-'}d', style: AppStyle.body5),
              ],
            ),

            // ── Comment ──────────────────────────────────────
            if (comment != null && comment!.isNotEmpty)
              Text(comment!, style: AppStyle.body6),

            // ── Edit + Delete — only my offer ─────────────────
            if (isMyOffer) ...[
              const SizedBox(height: 10),
              // Divider(color: Colors.grey.shade300, height: 1),
              // const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTailorButton(
                    text: 'Edit',
                    onPressed: onEdit,
                    icon: Icons.edit_outlined,
                    backgroundColor: AppColors.lightsecondary,
                    foregroundColor: AppColors.secondary,
                  ),
                  SizedBox(width: 20.w),
                  CustomTailorButton(
                    text: 'Delete',
                    onPressed: onDelete,
                    icon: Icons.delete_outline,
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: AppColors.ternary,
                  ),
                ],
              ),
            ],

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}