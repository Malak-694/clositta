import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final int maxLines;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  // Label properties (optional)
  final String? label;
  final TextStyle? labelStyle;
  final bool required;

  // Styling properties
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final bool filled;
  final double? borderRadius;

  // Size control properties
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const LabeledTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.focusNode,
    this.label,
    this.labelStyle,
    this.required = false,
    this.contentPadding,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.filled = false,
    this.borderRadius,
    this.height,
    this.width,
    this.constraints,
    this.textStyle,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    // If label is provided, wrap the text field with label
    if (label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(),
          SizedBox(height: 8.h),
          _buildTextField(context),
        ],
      );
    }

    // Otherwise, return just the text field
    return _buildTextField(context);
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Text(label!, style: labelStyle ?? AppStyle.body6),
        if (required) ...[
          SizedBox(width: 4.w),
          Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontSize: (labelStyle ?? AppStyle.body6).fontSize,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? 12.r;
    final effectiveBorderColor = borderColor ?? Colors.grey[300]!;
    final effectiveFocusedBorderColor =
        focusedBorderColor ?? Theme.of(context).primaryColor;

    final textField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator ?? (required ? _defaultValidator : null),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: textStyle ?? AppStyle.body6,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? AppStyle.smallBlack.copyWith(fontSize: 14.sp),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        filled: filled,
        fillColor: fillColor,

        // Border styling
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(color: effectiveBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(color: effectiveFocusedBorderColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(
            color: effectiveBorderColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(color: Colors.red[600]!, width: 2),
        ),
      ),
    );

    // If size constraints are provided, wrap the text field
    if (height != null || width != null) {
      return SizedBox(height: height, width: width, child: textField);
    }

    return textField;
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
