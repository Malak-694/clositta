import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.text,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });
  final text;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true; // default hide password
  @override
  void initState() {
    super.initState();
    // If value is passed and controller is empty, set it as default text
    // if (widget.text != null && widget.controller.text.isEmpty) {
    //   widget.controller.text = widget.text!;
    // }
  }

  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.lightprimery,
          // labelText: "Email",
          hintText: widget.text,
          hintStyle: AppStyle.body2.copyWith(fontSize: 17.sp),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.primery,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide(color: AppColors.lightprimery),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide(color: AppColors.lightprimery),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide(color: AppColors.lightprimery),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
