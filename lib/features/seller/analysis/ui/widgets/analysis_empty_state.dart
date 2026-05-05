import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';

class AnalysisEmptyState extends StatelessWidget {
  const AnalysisEmptyState({
    super.key,
    required this.isEmpty,
    required this.child,
    this.message = 'No data available',
  });

  final bool isEmpty;
  final Widget child;
  final String message;

  @override
  Widget build(BuildContext context) {
    if (!isEmpty) return child;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.light.withValues(alpha: 0.25)),
      ),
      child: Text(
        message,
        style: AppStyle.smallBlack.copyWith(color: AppColors.light),
        textAlign: TextAlign.center,
      ),
    );
  }
}
