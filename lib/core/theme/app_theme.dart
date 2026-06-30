import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primery,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primery,
        secondary: AppColors.darksecondary,
        surface: AppColors.background,
        error: AppColors.ternary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.dark),
        titleTextStyle: TextStyle(
          color: AppColors.dark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Raleway',
        ),
      ),
      cardColor: AppColors.lightprimery,
      iconTheme: const IconThemeData(color: AppColors.dark),
      dividerColor: AppColors.light,
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.dark,
        iconColor: AppColors.primery,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 12.h,
        ),
        hintStyle: AppStyle.smallBlack.copyWith(fontSize: 14.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primery, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.ternary),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.ternary, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkprimery,
        contentTextStyle: AppStyle.smallBackground.copyWith(fontSize: 13.sp),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        elevation: 3,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: TextTheme(
        bodyLarge:  TextStyle(color: AppColors.dark, fontFamily: 'Raleway'),
        bodyMedium: TextStyle(color: AppColors.dark, fontFamily: 'Raleway'),
        bodySmall:  TextStyle(color: AppColors.light, fontFamily: 'Raleway'),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkScaffold,
      primaryColor: AppColors.darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary:   AppColors.darkPrimary,
        secondary: AppColors.darkSecondaryMain,
        surface:   AppColors.darkSurface,
        error:     AppColors.darkTernary,
        onPrimary:  AppColors.darkTextPrimary,
        onSecondary: AppColors.darkScaffold,
        onSurface:  AppColors.darkTextPrimary,
        onError:    AppColors.darkScaffold,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkScaffold,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Raleway',
        ),
      ),
      cardColor: AppColors.darkSurface,
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      dividerColor: AppColors.darkDivider,
      listTileTheme: const ListTileThemeData(
        tileColor: AppColors.darkSurface,
        textColor: AppColors.darkTextPrimary,
        iconColor: AppColors.darkPrimaryLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkElevated,
        hintStyle: TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: 14.sp,
          fontFamily: 'Raleway',
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.darkBorder),
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.darkBorder),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.darkTernary),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.darkTernary, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkElevated,
        contentTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 13.sp,
          fontFamily: 'Raleway',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.darkElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge:   TextStyle(color: AppColors.darkTextPrimary,   fontFamily: 'Raleway'),
        bodyMedium:  TextStyle(color: AppColors.darkTextPrimary,   fontFamily: 'Raleway'),
        bodySmall:   TextStyle(color: AppColors.darkTextSecondary, fontFamily: 'Raleway'),
        titleLarge:  TextStyle(color: AppColors.darkTextPrimary,   fontFamily: 'Raleway', fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: AppColors.darkTextPrimary,   fontFamily: 'Raleway', fontWeight: FontWeight.w600),
        titleSmall:  TextStyle(color: AppColors.darkTextSecondary, fontFamily: 'Raleway', fontWeight: FontWeight.w600),
        labelLarge:  TextStyle(color: AppColors.darkTextPrimary,   fontFamily: 'Raleway'),
        labelSmall:  TextStyle(color: AppColors.darkTextSecondary, fontFamily: 'Raleway'),
      ),
    );
  }
}
