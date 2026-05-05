import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';

class AnalysisErrorView extends StatelessWidget {
  const AnalysisErrorView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.light.withValues(alpha: 0.25)),
        ),
        child: Text(
          message,
          style: AppStyle.body6.copyWith(color: AppColors.darkternary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
