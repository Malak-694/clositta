import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/seller/analysis/data/models/city_stats_model.dart';
import 'package:flutter/material.dart';

class AnalysisCityItem extends StatelessWidget {
  const AnalysisCityItem({super.key, required this.city});

  final CityStatsModel city;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.light.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_city_outlined, color: AppColors.ternary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(city.city, style: AppStyle.body6),
                const SizedBox(height: 2),
                Text('Orders: ${city.orders}', style: AppStyle.smallBlack),
              ],
            ),
          ),
          Text('\$${city.revenue}', style: AppStyle.boldTernary),
        ],
      ),
    );
  }
}
