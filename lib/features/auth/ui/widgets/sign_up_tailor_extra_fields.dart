import 'package:chicora/core/utils/validator.dart';
import 'package:chicora/features/auth/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Optional workshop address and Google Maps link when registering as a tailor.
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
        CustomTextFormField(
          text: "Workshop address (optional)",
          controller: workshopLocation,
          validator: (_) => null,
        ),
        SizedBox(height: 10.h),
        CustomTextFormField(
          text: "Google Maps URL (optional)",
          controller: mapsLink,
          validator: Validators.validateOptionalHttpUrl,
        ),
      ],
    );
  }
}
