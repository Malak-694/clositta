import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/auth/ui/widgets/custom_medium_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class RecoveryCodeScreen extends StatelessWidget {
  const RecoveryCodeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/password.png") , fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox( height : 180.h),
              SizedBox(
                height: 280.h,
                child: Image.asset("assets/images/email.png"),
              ),
              Text("Password Recovery" , style: AppStyle.headline1,),
              Text("Enter 4-digits code we sent you \n on your email",textAlign: TextAlign.center, style: AppStyle.body1,),
              SizedBox(
                height: 25.h,
              ),
              Pinput(
                length: 4, // 4 circles
                defaultPinTheme: PinTheme(
                  width: 30,
                  height: 30,
                  textStyle: AppStyle.body1,
                  decoration: BoxDecoration(
                    color: AppColors.lightprimery,      // background color of circle
                    borderRadius: BorderRadius.circular(25), // makes it round
                  ),
                ),
              ),
              SizedBox(
                height: 130.h,
              ),
              CustomMediumButton(value: "Send Again", onPressed: (){}, color: AppColors.ternary,isLoading: false,),
              SizedBox(
                height: 16.h,
              ),
              TextButton(onPressed: (){}, child: Text("cancel",style: AppStyle.body1,))
            ],
          ),
        ),
      ),
    );
  }
}
