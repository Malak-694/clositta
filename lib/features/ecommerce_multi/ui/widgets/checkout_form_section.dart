import 'package:chicora/core/widgets/labeled_text_field.dart';
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
    return SizedBox(
      height: 500.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LabeledTextField(
            controller: fullNameController,
            label: 'Full Name',
            hintText: 'Enter your full name',
            textInputAction: TextInputAction.next,
          ),
          LabeledTextField(
            controller: phoneController,
            label: 'Phone',
            hintText: '010xxxxxxxx',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          LabeledTextField(
            controller: addressController,
            label: 'Address',
            hintText: 'Street, building, apartment',
            maxLines: 2,
            textInputAction: TextInputAction.next,
          ),
          Row(
            children: [
              Expanded(
                child: LabeledTextField(
                  controller: cityController,
                  label: 'City',
                  hintText: 'City',
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: LabeledTextField(
                  controller: governorateController,
                  label: 'Governorate',
                  hintText: 'Governorate',
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          LabeledTextField(
            controller: postalCodeController,
            label: 'Postal Code',
            hintText: 'Postal code',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          LabeledTextField(
            controller: notesController,
            label: 'Notes',
            hintText: 'Optional delivery notes',
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
