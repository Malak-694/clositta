import 'package:chicora/features/ecommerce_multi/ui/widgets/checkout_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutFormSection extends StatelessWidget {
  const CheckoutFormSection({
    super.key,
    required this.fullNameController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.governorateController,
    required this.postalCodeController,
    required this.notesController,
    this.labelColor,
    this.fillColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
  });

  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController governorateController;
  final TextEditingController postalCodeController;
  final TextEditingController notesController;
  final Color? labelColor;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckoutTextField(
          controller: fullNameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          labelColor: labelColor,
          fillColor: fillColor,
          enabledBorderColor: enabledBorderColor,
          focusedBorderColor: focusedBorderColor,
        ),
        CheckoutTextField(
          controller: phoneController,
          label: 'Phone',
          hint: '010xxxxxxxx',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          labelColor: labelColor,
          fillColor: fillColor,
          enabledBorderColor: enabledBorderColor,
          focusedBorderColor: focusedBorderColor,
        ),
        CheckoutTextField(
          controller: addressController,
          label: 'Address',
          hint: 'Street, building, apartment',
          maxLines: 2,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          labelColor: labelColor,
          fillColor: fillColor,
          enabledBorderColor: enabledBorderColor,
          focusedBorderColor: focusedBorderColor,
        ),
        Row(
          children: [
            Expanded(
              child: CheckoutTextField(
                controller: cityController,
                label: 'City',
                hint: 'City',
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                labelColor: labelColor,
                fillColor: fillColor,
                enabledBorderColor: enabledBorderColor,
                focusedBorderColor: focusedBorderColor,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CheckoutTextField(
                controller: governorateController,
                label: 'Governorate',
                hint: 'Governorate',
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                labelColor: labelColor,
                fillColor: fillColor,
                enabledBorderColor: enabledBorderColor,
                focusedBorderColor: focusedBorderColor,
              ),
            ),
          ],
        ),
        CheckoutTextField(
          controller: postalCodeController,
          label: 'Postal Code',
          hint: 'Postal code',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          labelColor: labelColor,
          fillColor: fillColor,
          enabledBorderColor: enabledBorderColor,
          focusedBorderColor: focusedBorderColor,
        ),
        CheckoutTextField(
          controller: notesController,
          label: 'Notes',
          hint: 'Optional delivery notes',
          requiredField: false,
          maxLines: 3,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          labelColor: labelColor,
          fillColor: fillColor,
          enabledBorderColor: enabledBorderColor,
          focusedBorderColor: focusedBorderColor,
        ),
      ],
    );
  }
}
