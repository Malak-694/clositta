import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeasurementGuideCard extends StatelessWidget {
  const MeasurementGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'How to Measure Yourself',
              style: AppStyle.medPrimery.copyWith(fontSize: 16.sp),
            ),
            const SizedBox(height: 12),
            Image.asset(
              'assets/images/guide.png',
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}