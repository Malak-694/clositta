import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/features/customer/measurements/logic/cubit/measurements_cubit.dart';
import 'package:chicora/features/customer/measurements/ui/screens/measurement_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Profile menu tile that opens the measurements screen for customers.
class MeasurementsProfileTile extends StatelessWidget {
  final Color primaryColor;
  final Color lightColor;

  const MeasurementsProfileTile({
    super.key,
    required this.primaryColor,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.straighten_outlined, color: primaryColor, size: 24.sp),
        ),
        title: Text(
          'Body Measurements',
          style: AppStyle.body3.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Text(
          'Save your size for custom orders',
          style: AppStyle.medLight.copyWith(fontSize: 13.sp),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.light, size: 24.sp),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => getIt<MeasurementsCubit>()..getMeasurements(),
                child: const MeasurementScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}
