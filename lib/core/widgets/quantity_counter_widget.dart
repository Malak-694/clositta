import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityCounter extends StatelessWidget {
  const QuantityCounter({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.accent = AppColors.primery,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CounterButton(
          icon: Icons.remove,
          onTap: onDecrement,
          accent: accent,
        ),
        SizedBox(
          width: 40.w,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: AppStyle.body6,
          ),
        ),
        _CounterButton(
          icon: Icons.add,
          onTap: onIncrement,
          accent: accent,
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onTap,
    required this.accent,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(
          color: accent.withValues(alpha: 0.35),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 36.w,
          height: 36.h,
          child: Icon(
            icon,
            size: 18.sp,
            color: AppColors.dark,
          ),
        ),
      ),
    );
  }
}
