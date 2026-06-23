import 'package:chicora/features/ecommerce_multi/ui/widgets/comment_card_widget.dart';
import 'package:chicora/features/seller/products/data/models/rating_model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
    required this.productComments,
    this.userRating,
    this.currentUserId,
    this.onDelete,
    this.accent = AppColors.primery,
    this.accentDark = AppColors.darkprimery,
  });

  final List<RatingModel> productComments;
  final RatingModel? userRating;
  final String? currentUserId;
  final void Function(String ratingId)? onDelete;
  final Color accent;
  final Color accentDark;

  @override
  Widget build(BuildContext context) {
    print("iam here");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.forum_outlined, size: 22.sp, color: accentDark),
            SizedBox(width: 8.w),
            Text(
              'Customer reviews',
              style: AppStyle.body6.copyWith(
                color: accentDark,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Builder(
          builder: (context) {
            final combined = <RatingModel>[];
            if (userRating != null) combined.add(userRating!);
            combined.addAll(
              productComments.where(
                (c) => userRating == null || c.user.id != userRating!.user.id,
              ),
            );

            if (combined.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.lightprimery,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: accent.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.reviews_outlined,
                      size: 40.sp,
                      color: AppColors.light,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'No reviews yet',
                      textAlign: TextAlign.center,
                      style: AppStyle.body6,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Be the first to share your thoughts.',
                      textAlign: TextAlign.center,
                      style: AppStyle.medLight.copyWith(fontSize: 14.sp),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: combined.length,
              itemBuilder: (context, index) {
                final comment = combined[index];
                return CommentCard(
                  comment: comment,
                  accent: accent,
                  isOwn:
                      currentUserId != null && comment.user.id == currentUserId,
                  onDelete: onDelete,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
