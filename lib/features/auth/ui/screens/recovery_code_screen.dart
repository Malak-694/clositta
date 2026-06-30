import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_state.dart';
import 'package:chicora/features/auth/ui/widgets/custom_medium_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class RecoveryCodeScreen extends StatelessWidget {
  final String email;
  const RecoveryCodeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    String code = '';

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_) => Navigator.pushNamed(
            context,
            RouteNames.reset_password,
            arguments: email,
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
                    height: 280.h,
                    child: Image.asset("assets/images/email.png"),
                  ),
                  Text("Password Recovery", style: AppStyle.headline1),
                  Text(
                    "Enter 6-digits code we sent you \n on your email",
                    textAlign: TextAlign.center,
                    style: AppStyle.medBlack,
                  ),
                  SizedBox(height: 25.h),
                  Pinput(
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: 30,
                      height: 30,
                      textStyle: AppStyle.medBlack,
                      decoration: BoxDecoration(
                        color: AppColors.lightprimery,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onCompleted: (value) => code = value,
                  ),
                  SizedBox(height: 130.h),
                  CustomMediumButton(
                    value: "Verify",
                    isLoading: isLoading,
                    color: AppColors.ternary,
                    onPressed: isLoading
                        ? null
                        : () {
                      if (code.length == 6) {
                        context
                            .read<AuthCubit>()
                            .verifyResetCode(email, code);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter the full 6-digit code"),
                          ),
                        );
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
