import 'package:chicora/core/utils/validator.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpTailorExtraFields extends StatelessWidget {
  const SignUpTailorExtraFields({
    super.key,
    required this.visible,
    required this.workshopLocation,
    required this.mapsLink,
  });

  final bool visible;
  final TextEditingController workshopLocation;
  final TextEditingController mapsLink;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.h),
        LabeledTextField(
          label: "Workshop address (optional)",
          hintText: "",
          controller: workshopLocation,
        ),
        SizedBox(height: 10.h),
        LabeledTextField(
          label: "Google Maps URL (optional)",
          hintText: "",
          controller: mapsLink,
          validator: Validators.validateOptionalHttpUrl,
        ),
      ],
    );
  }
}
