import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart'; // assuming AppColors is defined here

class AppStyle {
  static BoxDecoration decoration({
    required double? radius,
    Color? color = AppColors.primery,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius!.r),
    );
  }

  static TextStyle get headline0 => TextStyle(
    fontSize: 52.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
    package: null,
    letterSpacing: 2.0,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = AppColors.dark,
  );

  static TextStyle get headline1 => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w900,
    fontFamily: 'Raleway',
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.dark,
  );

  // Body
  static TextStyle get headline2 => TextStyle(
    fontSize: 21.sp,

    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.dark,
  );
  static TextStyle get headline3 => TextStyle(
    fontSize: 17.sp,

    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.dark,
  );

  static TextStyle get body1 => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = AppColors.dark,
    fontFamily: 'Raleway',
  );
  static TextStyle get body2 => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = AppColors.primery,
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
