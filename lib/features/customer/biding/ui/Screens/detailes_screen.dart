

import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/customer/biding/ui/widgets/bid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailesScreen extends StatelessWidget {
  final String urlImage ;
  final String describtion ;
  final int bids_num ;


  const DetailesScreen({
    super.key,
    required this.urlImage,
    required this.describtion,
    required this.bids_num
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Back to Posts" , style: AppStyle.headline4,),
        leadingWidth: 20.w,
        iconTheme: IconThemeData(
          color: AppColors.ternary, // Change arrow color
        ),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tailor bids" , style: AppStyle.headline2,),
            SizedBox(height: 8.h,),
            Text("$bids_num Tailors interseted",style: AppStyle.body4,),
            SizedBox(height: 5.h,),
            Container(
              height: 275.h,
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                image: DecorationImage(image: AssetImage(urlImage),fit: BoxFit.cover),
              ),

            ),
            Text(describtion , style: AppStyle.body4,),
            SizedBox(height: 15.h,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListView(
                  children: [
                    BidItem(Tailor: "Ahmed Al-Tailor", duration: 7, price: 150, num_work: 210,comment: "I can create this beautiful dress with premium fabric. I have 5+ years of experience in formal wear.",),
                    SizedBox(height: 10,),
                    BidItem(Tailor: "Ahmed Al-Tailor", duration: 7, price: 150, num_work: 210),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
