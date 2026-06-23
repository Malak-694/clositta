import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostItemTailor extends StatelessWidget {
  final String title;
  final int bidCount;
  final String date;
  final String Image_url;
  final String price;
  final String period;
  final String status;
  final String id;

  const PostItemTailor({
    super.key,
    required this.title,
    required this.bidCount,
    required this.Image_url,
    required this.date,
    required this.status,
    required this.price,
    required this.period,
    required this.id,
  });

  Color get _statusColor {
    switch (status) {
      case 'closed':
        return Colors.red.shade100;
      case 'open':
        return Colors.green.shade100;
      default:
        return AppColors.lightprimery;
    }
  }

  Color get _statusTextColor {
    switch (status) {
      case 'closed':
        return Colors.red.shade700;
      case 'open':
        return Colors.green.shade700;
      default:
        return AppColors.primery;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightprimery),
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: AppColors.lightprimery,
              blurRadius: 5,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: Container(
                    height: 220.h,
                    width: double.infinity,
                    color: Colors.grey.shade50,
                    child: Image.network(
                      Image_url,
                      height: 220.h,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220.h,
                        color: Colors.grey.shade100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.checkroom, color: Colors.grey.shade400, size: 40),
                            SizedBox(height: 8.h),
                            Text('No image', style: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppStyle.medBlack,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),

                  Row(
                    children: [
                      if (price.isNotEmpty) ...[
                        Icon(Icons.attach_money,
                            size: 16.sp, color: AppColors.primery),
                        SizedBox(width: 2.w),
                        Text(price, style: AppStyle.medPrimery),
                        SizedBox(width: 12.w),
                      ],

                      Spacer(),
                      if (period.isNotEmpty) ...[
                        Icon(Icons.alarm,
                            size: 16.sp,
                            color: const Color(0xFF95989A)),
                        SizedBox(width: 4.w),
                        Text(period, style: AppStyle.body5),
                        SizedBox(width: 12.w),
                      ],

                      // const Spacer(),
                      //
                      // // Bids count
                      // if (bidCount > 0) ...[
                      //   Icon(Icons.gavel,
                      //       size: 14.sp,
                      //       color: const Color(0xFF95989A)),
                      //   SizedBox(width: 4.w),
                      //   Text(
                      //     '$bidCount bid${bidCount == 1 ? '' : 's'}',
                      //     style: AppStyle.medLight,
                      //   ),
                      // ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}