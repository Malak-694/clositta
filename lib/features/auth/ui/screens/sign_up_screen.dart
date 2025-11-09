import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/auth/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/colors.dart';
import '../widgets/custom_medium_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _type = TextEditingController();

  TextEditingController _email = TextEditingController();

  TextEditingController _password = TextEditingController();

  TextEditingController _confirm_password = TextEditingController();

  TextEditingController _phone = TextEditingController();

  String? _selectedType;
  final List<String> _types = ['User', 'Admin', 'Guest']; // example types

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/sign_up.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 130.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Create\nAccount", style: AppStyle.headline0),
                  SizedBox(width: 150.w),
                ],
              ),

              SizedBox(height: 25.h),
              SizedBox(
                width: 350.w,
                child: DropdownButtonFormField<String>(
                  value: _selectedType,
                  hint: Text("Type", style: AppStyle.body1),
                  items: _types.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type, style: AppStyle.body2),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  dropdownColor: AppColors.lightprimery,
                  borderRadius: BorderRadius.circular(25.r),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightprimery,

                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 18.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextFormField(text: "Email", controller: _email),
              SizedBox(height: 10.h),

              CustomTextFormField(
                text: "Password",
                controller: _password,
                isPassword: true,
              ),
              SizedBox(height: 10.h),

              CustomTextFormField(
                text: "Confirm Password",
                controller: _confirm_password,
                isPassword: true,
              ),
              SizedBox(height: 10.h),

              CustomTextFormField(text: "Phone", controller: _phone),

              SizedBox(height: 30.h),
              CustomMediumButton(
                value: "Done",
                onPressed: () {},
                color: AppColors.primery,
                width: MediaQuery.of(context).size.width - 60.w,
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.login);
                },
                child: Text("Already Our Friend ?", style: AppStyle.body1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
