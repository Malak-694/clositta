import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key , required this.value ,  required this.onPressed});

  final value ;
  final Function() onPressed ;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(value ,style: AppStyle.button,),
      style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primery,
      fixedSize: Size(335.w, 60.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
    ),);
  }
}
