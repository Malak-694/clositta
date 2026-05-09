import 'package:chicora/features/seller/products/data/models/rating_model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';

class CommentCard extends StatelessWidget {
  final RatingModel comment;
  final bool isOwn;
  final void Function(String ratingId)? onDelete;
  final Color accent;

  const CommentCard({
    super.key,
    required this.comment,
    this.isOwn = false,
    this.onDelete,
    this.accent = AppColors.primery,
  });

  String _formatDate(dynamic dateValue) {
    try {
      late DateTime dateTime;
      if (dateValue is DateTime) {
        dateTime = dateValue;
      } else if (dateValue is String) {
        dateTime = DateTime.parse(dateValue);
      } else {
        return 'N/A';
      }
      // Return formatted date: 2026-02-17
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    // Take first letter of first and last name
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: accent.withValues(alpha: 0.12),
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User avatar and name
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: accent.withValues(alpha: 0.2),
                    child: Text(
                      _getInitials(comment.user.name),
                      style: AppStyle.smallBlack.copyWith(
                        fontSize: 11.sp,
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.user.name,
                        style: AppStyle.body6.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        _formatDate(comment.updatedAt),
                        style: AppStyle.caption.copyWith(
                          color: AppColors.light,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Rating stars
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_rounded,
                    size: 16.sp,
                    color: index < comment.rating
                        ? AppColors.secondary
                        : AppColors.light.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Comment text
          Row(
            children: [
              Expanded(
                child: Text(
                  comment.comment,
                  style: AppStyle.medLight.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.dark,
                    height: 1.4,
                  ),
                  softWrap: true,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isOwn)
                IconButton(
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.ternary,
                  ),
                  icon: Icon(Icons.delete_outline_rounded, size: 20.sp),
                  onPressed: () {
                    onDelete?.call(comment.id);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
