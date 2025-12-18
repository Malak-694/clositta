import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/features/auth/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';


class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});


  @override
  Widget build(BuildContext context) {
    TextEditingController password = TextEditingController() ;
    TextEditingController confirmPassword = TextEditingController();

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
                height: 220.h,
                child: Image.asset("assets/images/lock.png"),
              ),
              Text("setup new passpassword" , style: AppStyle.headline1,),
              Text("Please, setup a new password \nfor your account",textAlign: TextAlign.center, style: AppStyle.body1,),
              SizedBox(
                height: 25.h,
              ),
              CustomTextFormField(text: "password", controller: password ,isPassword: true,),
              SizedBox(height: 10.h,),
              CustomTextFormField(text: "confirm password", controller: confirmPassword , isPassword: true,),
              SizedBox(
                height: 90.h,
              ),
              CustomElevatedButton(value: "Save", onPressed: (){}),
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

