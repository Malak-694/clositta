import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/features/auth/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/cubit/authentication_cubit.dart';
import '../../logic/cubit/authentication_state.dart';


class PasswordRecoveryScreen extends StatelessWidget {
  final TextEditingController _email = TextEditingController();
  PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_) => Navigator.pushNamed(
            context,
            RouteNames.recovery_code,
            arguments: _email.text.trim(),
          ),
          fail: (error) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error))),
        );
      },
      builder: (context, state) {
        final isLoading = state == const AuthState.loading();
        return Scaffold(
          backgroundColor: AppColors.background,
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
                  SizedBox(height: 200.h),
                  SizedBox(
                    height: 280.h,
                    child: Image.asset("assets/images/recovery.png"),
                  ),
                  Text("Password Recovery", style: AppStyle.headline1),
                  Text(
                    "Enter your email to send \n recovery code",
                    textAlign: TextAlign.center,
                    style: AppStyle.medBlack,
                  ),
                  SizedBox(height: 25.h),
                  CustomTextFormField(text: "Email", controller: _email),
                  SizedBox(height: 90.h),
                  CustomElevatedButton(
                    value: isLoading ? "Sending..." : "Next",
                    onPressed: () {
                      if (isLoading) return;
                      if (_email.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter your email"),
                          ),
                        );
                        return;
                      }
                      context
                          .read<AuthCubit>()
                          .forgotPassword(_email.text.trim());
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => Navigator.pushNamed(context, RouteNames.login),
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