import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_state.dart';
import 'package:chicora/features/auth/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController password = TextEditingController();
    final TextEditingController confirmPassword = TextEditingController();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_) => Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.login,
                (route) => false,
          ),
          fail: (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          ),
        );
      },
      builder: (context, state) {
        final isLoading = state == const AuthState.loading();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/password.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 180.h),
                  SizedBox(
                    height: 220.h,
                    child: Image.asset("assets/images/lock.png"),
                  ),
                  Text("Setup New Password", style: AppStyle.headline1),
                  Text(
                    "Please, setup a new password \nfor your account",
                    textAlign: TextAlign.center,
                    style: AppStyle.medBlack,
                  ),
                  SizedBox(height: 25.h),
                  CustomTextFormField(
                    text: "Password",
                    controller: password,
                    isPassword: true,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextFormField(
                    text: "Confirm Password",
                    controller: confirmPassword,
                    isPassword: true,
                  ),
                  SizedBox(height: 90.h),
                  CustomElevatedButton(
                    value: isLoading ? "Saving..." : "Save",
                    onPressed: () {
                      if (isLoading) return;
                      if (password.text.isEmpty || confirmPassword.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill in all fields")),
                        );
                      } else if (password.text != confirmPassword.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Passwords don't match")),
                        );
                      } else if (password.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password must be at least 6 characters")),
                        );
                      } else {
                        context.read<AuthCubit>().resetPassword(email, password.text);
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      Navigator.pushNamed(context, RouteNames.login);
                    },
                    child: Text("cancel", style: AppStyle.medBlack),
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