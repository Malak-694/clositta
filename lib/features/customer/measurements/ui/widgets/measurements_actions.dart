import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeasurementsActions extends StatelessWidget {
  final bool hasExistingMeasurements;
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const MeasurementsActions({
    super.key,
    required this.hasExistingMeasurements,
    required this.isLoading,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: CircularProgressIndicator(color: AppColors.primery),
          ),
        CustomElevatedButton(
          value: hasExistingMeasurements
              ? 'Update Measurements'
              : 'Save Measurements',
          style: AppStyle.medBackground.copyWith(fontSize: 16.sp),
          onPressed: isLoading ? () {} : onSave,
          background: AppColors.primery,
        ),
        if (hasExistingMeasurements) ...[
          SizedBox(height: 12.h),
          CustomElevatedButton(
            value: 'Delete Measurements',
            style: AppStyle.medBackground.copyWith(fontSize: 16.sp),
            onPressed: isLoading ? () {} : onDelete,
            background: AppColors.ternary,
          ),
        ],
      ],
    );
  }
}

class MeasurementsSummaryCard extends StatelessWidget {
  final double chest;
  final double waist;
  final double hips;
  final String unit;

  const MeasurementsSummaryCard({
    super.key,
    required this.chest,
    required this.waist,
    required this.hips,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Measurements',
            style: AppStyle.medPrimery.copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem('Chest', chest),
              _summaryItem('Waist', waist),
              _summaryItem('Hips', hips),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, double value) {
    return Column(
      children: [
        Text(label, style: AppStyle.smallBlack.copyWith(fontSize: 12.sp)),
        SizedBox(height: 4.h),
        Text(
          '${value.toStringAsFixed(1)} $unit',
          style: AppStyle.body6.copyWith(fontSize: 15.sp),
        ),
      ],
    );
  }
}
