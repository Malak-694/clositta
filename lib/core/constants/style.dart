import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart'; // assuming AppColors is defined here

class AppStyle {
  static BoxDecoration decoration({required double? radius, Color? color = AppColors.primery  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius!.r),

    );
    
  }
   static TextStyle get headline0 => TextStyle(
    fontSize: 52.sp,
    fontWeight: FontWeight.w700 ,
    color: AppColors.dark,
    fontFamily: 'Raleway',
    package: null,
  );

  static TextStyle get headline1 => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold ,
    color: AppColors.dark,
    fontFamily: 'Raleway',
  );

  // Body
  static TextStyle get headline2 => TextStyle(
    fontSize: 21.sp,
    color: AppColors.dark,
    fontWeight: FontWeight.w700 ,
    fontFamily: 'Raleway',
  );
  static TextStyle get headline3 => TextStyle(
    fontSize: 17.sp,
    color: AppColors.dark,
    fontWeight: FontWeight.w700 ,
    fontFamily: 'Raleway',
  );

  static TextStyle get body1 => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,
    
    color: AppColors.dark,
    fontFamily: 'Raleway',
  );

  // Captions
  static TextStyle get caption => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
    fontFamily: 'Raleway',
  );

  // Buttons
  static TextStyle get button => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w900,
    color: AppColors.lightprimery,
    fontFamily: 'Raleway',
  );
}