import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/auth/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../widgets/custom_medium_button.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 350.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Login", style: AppStyle.headline0),
                      Text(
                        "Good to see you back",
                        textAlign: TextAlign.start,
                        style: AppStyle.body1.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 150.w),
                ],
              ),

              SizedBox(height: 25.h),
              CustomTextFormField(text: "Email", controller: _email),
              SizedBox(height: 10.h),

              CustomTextFormField(
                text: "Password",
                controller: _password,
                isPassword: true,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.passord_recovery);
                    },
                    child: Text(
                      "Forget your password ",
                      style: AppStyle.body1.copyWith(fontSize: 18.sp),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(width: 140.w),
                ],
              ),
              SizedBox(height: 20.h),

              CustomMediumButton(
                value: "Next",
                onPressed: () {
                  // Navigate to next screen
                },
                color: AppColors.primery,
                width: MediaQuery.of(context).size.width - 60.w,
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.singUp);
                },
                child: Text("First time to see us?", style: AppStyle.body1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
