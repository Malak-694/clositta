import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/helper/notification_helper.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/utils/validator.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
import 'package:chicora/features/auth/data/model/google_auth_model.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_state.dart';
import 'package:chicora/features/auth/ui/widgets/custom_medium_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../data/model/login_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
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
          success: (data) {
            NotificationHelper.sendTokenToBackend();
            if (data is LoginResponse || data is GoogleAuthResponseModel) {
              if (data.role == 'customer') {
                Navigator.pushReplacementNamed(
                  context,
                  RouteNames.customer_products_screen,
                );
              } else if (data.role == 'tailor') {
                Navigator.pushReplacementNamed(
                  context,
                  RouteNames.view_bidding_tailor,
                );
              } else if (data.role == 'clothes_seller' ||
                  data.role == 'material_seller') {
                Navigator.pushReplacementNamed(
                  context,
                  RouteNames.seller_products_screen,
                );
              } else {
                Navigator.pushReplacementNamed(context, RouteNames.login);
              }
            }
          },
          fail: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStyle.userMessage(error))),
            );
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login.png"),
                    fit: BoxFit.cover,
                  ),
                ),
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
                            Text("Login", style: AppStyle.boldBlack),
                            Text(
                              "Good to see you back",
                              textAlign: TextAlign.start,
                              style: AppStyle.medBlack,
                            ),
                          ],
                        ),
                        SizedBox(width: 150.w),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SizedBox(height: 25.h),
                            LabeledTextField(
                              label: "Email",
                              hintText: "Enter your email",
                              controller: _email,
                              validator: Validators.validateEmail,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 10.h),

                            LabeledTextField(
                              label: "Password",
                              hintText: "Enter your password",
                              controller: _password,
                              obscureText: true,
                              validator: Validators.validatePassword,
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(height: 30.h),
                            CustomMediumButton(
                              value: "LogIn",
                              isLoading: state is Loading,
                              onPressed: state is Loading
                                  ? () {}
                                  : _handleLogin,
                              color: AppColors.primery,
                              width: MediaQuery.of(context).size.width - 60.w,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.password_recovery,
                            );
                          },
                          child: Text(
                            "Forget your password ",
                            style: AppStyle.smallPrimery.copyWith(
                              fontSize: 18.sp,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(width: 140.w),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    TextButton(
                      onPressed: state is Loading
                          ? null
                          : () {
                              context.read<AuthCubit>().googleAuth();
                            },
                      child: Text(
                        "- Sign in with google -",
                        style: AppStyle.smallBlack.copyWith(fontSize: 15.sp),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.sign_up);
                      },
                      child: Text(
                        "First time to see us?",
                        style: AppStyle.smallBlack.copyWith(fontSize: 15.sp),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
