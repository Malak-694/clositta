import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/customer/measurements/ui/widgets/measurement_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeasurementsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController chestController;
  final TextEditingController waistController;
  final TextEditingController hipsController;
  final TextEditingController shouldersController;
  final TextEditingController armLengthController;
  final TextEditingController inseamController;
  final TextEditingController heightController;
  final String unit;
  final ValueChanged<String> onUnitChanged;

  const MeasurementsForm({
    super.key,
    required this.formKey,
    required this.chestController,
    required this.waistController,
    required this.hipsController,
    required this.shouldersController,
    required this.armLengthController,
    required this.inseamController,
    required this.heightController,
    required this.unit,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          _buildUnitSelector(),
          SizedBox(height: 20.h),
          MeasurementField(
            controller: chestController,
            label: 'Chest',
            hint: 'e.g. 96',
            unit: unit,
          ),
          SizedBox(height: 16.h),
          MeasurementField(
            controller: waistController,
            label: 'Waist',
            hint: 'e.g. 78',
            unit: unit,
          ),
          SizedBox(height: 16.h),
          MeasurementField(
            controller: hipsController,
            label: 'Hips',
            hint: 'e.g. 102',
            unit: unit,
            
          ),
          SizedBox(height: 16.h),
          MeasurementField(
            controller: shouldersController,
            label: 'Shoulders',
            hint: 'e.g. 44',
            unit: unit,
          ),
          SizedBox(height: 16.h),
          MeasurementField(
            controller: armLengthController,
            label: 'Arm Length',
            hint: 'e.g. 60',
            unit: unit,
          ),
          SizedBox(height: 16.h),
          MeasurementField(
            controller: inseamController,
            label: 'Inseam',
            hint: 'e.g. 78',
            unit: unit,
          ),
          SizedBox(height: 16.h),
          MeasurementField(
            controller: heightController,
            label: 'Height',
            hint: 'e.g. 170',
            unit: unit,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Unit', style: AppStyle.body6),
        SizedBox(height: 8.h),
        Row(
          children: [
            _unitChip('cm'),
            SizedBox(width: 12.w),
            _unitChip('in'),
          ],
        ),
      ],
    );
  }

  Widget _unitChip(String value) {
    final selected = unit == value;
    return GestureDetector(
      onTap: () => onUnitChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primery : AppColors.background,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.primery : AppColors.light,
          ),
        ),
        child: Text(
          value.toUpperCase(),
          style: AppStyle.smallBlack.copyWith(
            fontSize: 14.sp,
            color: selected ? AppColors.background : AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
