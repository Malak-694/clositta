import 'package:chicora/features/seller/analysis/data/models/avg_order_model.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_stat_tile.dart';
import 'package:flutter/material.dart';

class AnalysisAverageOrderRow extends StatelessWidget {
  const AnalysisAverageOrderRow({super.key, required this.avgOrderValue});

  final AvgOrderValueModel? avgOrderValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnalysisStatTile(
            label: 'Without Shipping',
            value: '\$${avgOrderValue?.avgOrderValue}',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AnalysisStatTile(
            label: 'With Shipping',
            value: '\$${avgOrderValue?.avgWithShipping}',
          ),
        ),
      ],
    );
  }
}
