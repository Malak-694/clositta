import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/post_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Screens/join_bidding_screen.dart';

class PostItemTailor extends StatelessWidget {
  final String title;
  final int bidCount;
  final String date;
  final String Image_url;
  final String price;
  final String period;
  final String status;

  const PostItemTailor({
    super.key,
    required this.title,
    required this.bidCount,
    required this.Image_url,
    required this.date,
    required this.status,
    required this.price,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 270.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/clothes1.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  softWrap: true,
                  style: AppStyle.body1.copyWith(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = .5
                      ..color = AppColors.dark,
                  ),
                  overflow: null,
                ),
              ),
              SizedBox(width: 10.w),
              if (price.isNotEmpty || period.isNotEmpty)
                SizedBox(
                  width: 65,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 51,

                        child: Text(
                          price,
                          textAlign: TextAlign.center,
                          style: AppStyle.body2.copyWith(
                            fontSize: 20.sp,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1
                              ..color = AppColors.primery,
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.alarm,
                            color: const Color(0xFF95989A),
                            size: 12,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            period,
                            style: AppStyle.body6.copyWith(
                              fontSize: 12.sp,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1
                                ..color = const Color(0xFF95989A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: 5.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bids count
              Text(
                '$bidCount bid${bidCount == 1 ? '' : 's'} . $date',
                style: AppStyle.body4,
              ),
              status == "selected"
                  ? Container()
                  : StatusBadge(status: status, isSelected: false),
            ],
          ),
          SizedBox(height: 8.h),
          status == "selected"
              ? Container()
              : CustomElevatedButton(
                  value: 'join Bidding',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinBiddingScreen(
                          imageUrl: Image_url,
                          price: price,
                          period: period,
                          title: title,
                        ),
                      ),
                    );
                  },
                  height: 39,
                  width: 260,
                ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
