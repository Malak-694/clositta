import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';

class AnalysisStatTile extends StatelessWidget {
  const AnalysisStatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.light.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.lightternary, size: 25),
            const SizedBox(width: 8),
          ],
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppStyle.smallBlack),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppStyle.boldTernary.copyWith(
                    color: AppColors.darkternary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
