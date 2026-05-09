import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/seller/analysis/data/models/revenue_model.dart';
import 'package:flutter/material.dart';

class AnalysisRevenueList extends StatelessWidget {
  const AnalysisRevenueList({
    super.key,
    required this.items,
    required this.getLabel,
    required this.getSubLabel,
  });

  final List<RevenuePeriodModel> items;
  final String Function(RevenuePeriodModel item) getLabel;
  final String Function(RevenuePeriodModel item) getSubLabel;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.light.withValues(alpha: 0.25)),
        ),
        child: Text(
          'No revenue data available',
          style: AppStyle.smallBlack.copyWith(color: AppColors.light),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: items
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.light.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getLabel(item), style: AppStyle.body6),
                        const SizedBox(height: 2),
                        Text(getSubLabel(item), style: AppStyle.smallBlack),
                      ],
                    ),
                  ),
                  Text(
                    '\$${item.revenue}',
                    style: AppStyle.boldTernary.copyWith(color: AppColors.darkternary),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
