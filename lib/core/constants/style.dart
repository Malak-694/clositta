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

  //BOLD
  static TextStyle get boldBlack => TextStyle(
    fontSize: 52.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
    package: null,
    letterSpacing: 2.0,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.dark,
  );
  static TextStyle get boldPrimery => TextStyle(
    fontSize: 17.sp,

    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.primery,
  );

  static TextStyle get boldSecondary => TextStyle(
    fontSize: 21.sp,

    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.secondary,
  );

  static TextStyle get boldTernary => TextStyle(
    fontSize: 17.sp,

    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.ternary,
  );
  //Medium
  static TextStyle get medBlack => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .5
      ..color = AppColors.dark,
    fontFamily: 'Raleway',
  );
  static TextStyle get medPrimery => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .5
      ..color = AppColors.primery,
    fontFamily: 'Raleway',
  );
  static TextStyle get medSecondary => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .5
      ..color = AppColors.secondary,
    fontFamily: 'Raleway',
  );
  static TextStyle get medTernary => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .5
      ..color = AppColors.ternary,
    fontFamily: 'Raleway',
  );
  static TextStyle get medBackground => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .5
      ..color = AppColors.background,
    fontFamily: 'Raleway',
  );
  //Small
  static TextStyle get smallBlack => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = AppColors.dark,

    fontFamily: 'Raleway',
  );
  static TextStyle get smallPrimery => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = AppColors.primery,
    fontFamily: 'Raleway',
  );
  static TextStyle get smallSecondary => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = AppColors.secondary,
    fontFamily: 'Raleway',
  );
  static TextStyle get smallTernary => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = AppColors.ternary,
    fontFamily: 'Raleway',
  );
  static TextStyle get smallBackground => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = Colors.white,
    fontFamily: 'Raleway',
  );

  //OLD
  static TextStyle get headline1 => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w900,
    fontFamily: 'Raleway',
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.dark,
  );

  static TextStyle get body3 => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = AppColors.darkprimery,
    fontFamily: 'Raleway',
  );

  static TextStyle get medLight => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w600,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = const Color.fromARGB(255, 121, 120, 120),
    fontFamily: 'Raleway',
  );

  static TextStyle get body5 => TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = AppColors.light,
    fontFamily: 'Raleway',
  );
  static TextStyle get body6 => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,

    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .3
      ..color = AppColors.dark,
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
