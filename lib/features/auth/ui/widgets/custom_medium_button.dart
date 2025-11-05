
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMediumButton extends StatelessWidget {
  const CustomMediumButton({super.key , required this.value ,  required this.onPressed , required this.color} );

  final value ;
  final Function() onPressed ;
  final Color color ;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(value ,style: AppStyle.button,),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        fixedSize: Size(220.w, 55.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),);
  }
}
