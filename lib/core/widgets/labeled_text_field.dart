import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabeledTextField extends StatefulWidget {
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
  final bool obscureText;

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
    this.filled = true, // match CheckoutTextField: filled by default
    this.borderRadius,
    this.height,
    this.width,
    this.constraints,
    this.textStyle,
    this.hintStyle,
    this.obscureText = false,
  });

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    // Label now lives inside the field (floating label), so just return the field
    return _buildTextField(context);
  }

  Widget _buildTextField(BuildContext context) {
    final effectiveBorderRadius = widget.borderRadius ?? 12.r;
    final effectiveBorderColor = widget.borderColor ?? AppColors.lightprimery;
    final effectiveFocusedBorderColor =
        widget.focusedBorderColor ?? AppColors.primery;
    final effectiveFillColor = widget.fillColor ?? AppColors.lightprimery;

    // Build the floating label text, appending '*' when required
    final effectiveLabelText = widget.label == null
        ? null
        : (widget.required ? '${widget.label!} *' : widget.label!);

    final textField = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      maxLines: widget.obscureText
          ? 1
          : widget.maxLines, // obscured fields shouldn't be multiline
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText ? _obscureText : false,
      validator:
          widget.validator ?? (widget.required ? _defaultValidator : null),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: widget.textStyle ?? AppStyle.body3,
      decoration: InputDecoration(
        labelText: effectiveLabelText,
        labelStyle:
            widget.labelStyle ??
            AppStyle.smallPrimery.copyWith(
              fontSize: 13.sp,
              color: AppColors.primery,
            ),
        hintText: widget.hintText,
        hintStyle:
            widget.hintStyle ??
            AppStyle.smallBlack.copyWith(
              fontSize: 14.sp,
              color: AppColors.light,
            ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
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
            : widget.suffixIcon,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        filled: widget.filled,
        fillColor: widget.controller.text.isNotEmpty
            ? AppColors.primery.withValues(alpha: 0.1)
            : effectiveFillColor,

        // Border styling
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(color: effectiveBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(
            color: effectiveFocusedBorderColor,
            width: 1.2,
          ),
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
    if (widget.height != null || widget.width != null) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: textField,
      );
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
