import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/helper/notification_helper.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/utils/validator.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_state.dart';
import 'package:chicora/features/auth/ui/widgets/custom_text_form_field.dart';
import 'package:chicora/features/auth/ui/widgets/drop_down_type.dart';
import 'package:chicora/features/auth/ui/widgets/sign_up_tailor_extra_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../widgets/custom_medium_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _confirm_password = TextEditingController();

  final TextEditingController _phone = TextEditingController();

  final TextEditingController _workshopLocation = TextEditingController();

  final TextEditingController _mapsLink = TextEditingController();

  String? _selectedType;
  final List<String> _types = [
    'Customer',
    'Tailor',
    'Admin',
    'Clothes Seller',
    'Material Seller',
  ]; // example types
  void _handleSignUp() {
    final String name = _name.text.trim();
    final String email = _email.text.trim();
    final String password = _password.text.trim();
    final String confirmPassword = _confirm_password.text.trim();
    final String phone = _phone.text.trim();
    final String role = _selectedType ?? 'User';
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signUp(
        name,
        email,
        password,
        confirmPassword,
        phone,
        role,
        workshopLocation:
            _selectedType == 'Tailor' ? _workshopLocation.text : null,
        workshopMapsUrl: _selectedType == 'Tailor' ? _mapsLink.text : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          success: (message) {
            NotificationHelper.sendTokenToBackend();
            Navigator.pushNamed(context, RouteNames.login);
          },
          fail: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(AppStyle.userMessage(error))));
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
                      Text("Create\nAccount", style: AppStyle.boldBlack),
                      SizedBox(width: 150.w),
                    ],
                  ),

                  SizedBox(height: 25.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(text: "Name", controller: _name),

                        SizedBox(height: 10.h),
                        CustomTextFormField(
                          text: "Email",
                          controller: _email,
                          validator: Validators.validateEmail,
                        ),
                        SizedBox(height: 10.h),

                        CustomTextFormField(
                          text: "Phone",
                          controller: _phone,
                          validator: Validators.validateOptionalPhone,
                        ),
                        SizedBox(height: 10.h),

                        CustomTextFormField(
                          text: "Password",
                          controller: _password,
                          isPassword: true,
                          validator: Validators.validatePassword,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextFormField(
                          text: "Confirm Password",
                          controller: _confirm_password,
                          isPassword: true,
                          validator: (value) =>
                              Validators.validateConfirmPassword(
                                value,
                                _password.text,
                              ),
                        ),

                        SizedBox(height: 10.h),

                        CustomDropdown(
                          items: _types,
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                        ),

                        SignUpTailorExtraFields(
                          visible: _selectedType == 'Tailor',
                          workshopLocation: _workshopLocation,
                          mapsLink: _mapsLink,
                        ),

                        SizedBox(height: 30.h),
                        CustomMediumButton(
                          value: "Sign Up",
                          isLoading: state is Loading,
                          onPressed: state is Loading ? () {} : _handleSignUp,
                          color: AppColors.primery,
                          width: MediaQuery.of(context).size.width - 60.w,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.login);
                    },
                    child: Text(
                      "Already Our Friend ?",
                      style: AppStyle.medBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm_password.dispose();
    _phone.dispose();
    _workshopLocation.dispose();
    _mapsLink.dispose();
    super.dispose();
  }
}
