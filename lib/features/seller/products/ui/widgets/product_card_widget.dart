import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';

Color _getStatusColor(String status) {
  switch (status) {
    case 'Active':
      return Colors.green;
    case 'Low Stock':
      return Colors.orange;
    case 'Out of Stock':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

Widget _buildStarRating(double rating) {
  return Row(
    children: [
      Icon(Icons.star, color: Colors.amber, size: 16),
      Text(
        '$rating',
        style: AppStyle.body6.copyWith(
          fontSize: 12.sp,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = .4
            ..color = AppColors.primery,
        ),
      ),
    ],
  );
}

Widget buildFabricCard(Map<String, dynamic> fabric) {
  final name = fabric['name'] as String;
  final rating = fabric['rating'] as double;
  final soldCount = fabric['soldCount'] as int;
  final pricePerYard = fabric['pricePerYard'] as double;
  final stock = fabric['stock'] as int;
  final status = fabric['status'] as String;
  final imageUrl = fabric['image'] as String;

  return Container(
    height: 135.h,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.all(16.h),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            imageUrl,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppStyle.body1.copyWith(
                fontSize: 14.sp,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = .5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                _buildStarRating(rating),
                SizedBox(width: 8.w),
                Text(
                  '• $soldCount sold',
                  style: AppStyle.body6.copyWith(
                    fontSize: 12.sp,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = .4
                      ..color = AppColors.primery,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              '\$$pricePerYard/yd',
              style: AppStyle.body2.copyWith(
                fontSize: 16.sp,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = .4
                  ..color = AppColors.ternary,
              ),
            ),
            Text(
              'Stock: $stock',
              style: AppStyle.body6.copyWith(
                fontSize: 12.sp,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = .4
                  ..color = AppColors.primery,
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(status), width: 1),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
