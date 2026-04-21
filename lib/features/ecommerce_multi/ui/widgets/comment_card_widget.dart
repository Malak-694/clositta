import 'package:chicora/features/seller/products/data/models/rating_model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';

class CommentCard extends StatelessWidget {
  final RatingModel comment;
  final bool isOwn;
  final void Function(String ratingId)? onDelete;

  const CommentCard({
    super.key,
    required this.comment,
    this.isOwn = false,
    this.onDelete,
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(12),
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
                    radius: 15,
                    backgroundColor: AppColors.primery,
                    child: Text(
                      _getInitials(comment.user.name),
                      style: AppStyle.medBackground.copyWith(fontSize: 10.sp),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.user.name,
                        style: AppStyle.medPrimery.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        _formatDate(comment.updatedAt),
                        style: AppStyle.medLight.copyWith(fontSize: 10.sp),
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
                    Icons.star,
                    size: 16,
                    color: index < comment.rating
                        ? Colors.amber
                        : Colors.grey[300],
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
                  style: AppStyle.medBlack.copyWith(fontSize: 16.sp),
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isOwn)
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () {
                    if (onDelete != null) onDelete!(comment.id);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
