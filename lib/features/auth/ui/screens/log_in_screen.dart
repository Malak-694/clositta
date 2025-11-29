import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/utils/validator.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_state.dart';
import 'package:chicora/features/auth/ui/widgets/custom_medium_button.dart';
import 'package:chicora/features/auth/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  void _handleLogin() {
    final String email = _email.text.trim();
    final String password = _password.text.trim();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().logIn(email, password);
    }
  }

  // Add form key
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          success: (message) {
            Navigator.pushNamed(context, RouteNames.passord_recovery);
          },
          fail: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error)));
          },
        );
      },
      builder: (context, state) {
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 25.h),
                        CustomTextFormField(
                          text: "Email",
                          controller: _email,
                          validator: Validators.validateEmail,
                        ),
                        SizedBox(height: 10.h),

                        CustomTextFormField(
                          text: "Password",
                          controller: _password,
                          isPassword: true,
                          validator: Validators.validatePassword,
                        ),
                        SizedBox(height: 30.h),
                        CustomMediumButton(
                          value: "LogIn",
                          isLoading: state is Loading,
                          onPressed: state is Loading ? () {} : _handleLogin,
                          color: AppColors.primery,
                          width: MediaQuery.of(context).size.width - 60.w,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.passord_recovery,
                          );
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

                  // CustomMediumButton(
                  //   value: "Next",
                  //   onPressed: () {
                  //     // Navigate to next screen
                  //   },
                  //   color: AppColors.primery,
                  //   width: MediaQuery.of(context).size.width - 60.w,
                  // ),
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
      },
    );
  }
}
