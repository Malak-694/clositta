import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/seller/analysis/data/models/product_stats_model.dart';
import 'package:flutter/material.dart';

class AnalysisProductItem extends StatelessWidget {
  const AnalysisProductItem({super.key, required this.product});

  final ProductStatsModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.light.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.productImage,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 48,
                height: 48,
                color: Colors.white,
                child: const Icon(Icons.image_not_supported_outlined, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.productName, style: AppStyle.body6),
                const SizedBox(height: 2),
                Text(
                  'Qty: ${product.totalQuantitySold} | Orders: ${product.timesOrdered}',
                  style: AppStyle.smallBlack,
                ),
              ],
            ),
          ),
          Text(
            '\$${product.totalRevenue}',
            style: AppStyle.boldTernary.copyWith(color: AppColors.darkternary),
          ),
        ],
      ),
    );
  }
}
