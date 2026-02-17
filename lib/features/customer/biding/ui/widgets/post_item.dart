import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostItem extends StatelessWidget {
  final String title;
  final int? bidCount;
  final String date;
  final String Image_url;
  final String status;

  const PostItem({
    super.key,
    required this.title,
    this.bidCount,
    required this.Image_url,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 382.h,
      width: 400.w,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 290.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(Image_url),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          Text(title, style: AppStyle.medBlack),

          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bids count
              Text(
                // '$bidCount bid${bidCount == 1 ? '' : 's'} . $date',
                date,
                style: AppStyle.medLight,
              ),
              Container(
                height: 30.h,
                width: 65.w,
                margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  color: status == "selected"
                      ? AppColors.light
                      : Colors.greenAccent,
                  border: BoxBorder.all(
                    color: status == "selected" ? AppColors.dark : Colors.green,
                  ),
                ),
                child: Center(
                  child: Text(
                    status,
                    style: TextStyle(
                      color: status == "selected"
                          ? AppColors.dark
                          : Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
