import 'package:chicora/features/seller/analysis/data/models/overview_model.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_stat_tile.dart';
import 'package:flutter/material.dart';

class AnalysisOverviewGrid extends StatelessWidget {
  const AnalysisOverviewGrid({super.key, required this.overview});

  final OverviewModel overview;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AnalysisStatTile(
                label: 'Total Revenue',
                value: '\$${overview.totalRevenue}',
                icon: Icons.payments_outlined,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AnalysisStatTile(
                label: 'Total Orders',
                value: '${overview.totalOrders}',
                icon: Icons.shopping_bag_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AnalysisStatTile(
                label: 'Items Sold',
                value: '${overview.totalItemsSold}',
                icon: Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AnalysisStatTile(
                label: 'Cancelled Orders',
                value: '${overview.cancelledOrders}',
                icon: Icons.cancel_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnalysisStatTile(
          label: 'Shipping Collected',
          value: '\$${overview.totalShippingCollected}',
          icon: Icons.local_shipping_outlined,
        ),
      ],
    );
  }
}
