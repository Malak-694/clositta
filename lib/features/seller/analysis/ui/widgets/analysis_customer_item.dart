import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/seller/analysis/data/models/top_customer_model.dart';
import 'package:flutter/material.dart';

class AnalysisCustomerItem extends StatelessWidget {
  const AnalysisCustomerItem({super.key, required this.customer});

  final TopCustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.light.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.ternary,
            child: Icon(Icons.person, color: AppColors.background, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name, style: AppStyle.body6),
                const SizedBox(height: 2),
                Text(customer.email, style: AppStyle.smallBlack),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${customer.totalSpent}', style: AppStyle.boldTernary),
              const SizedBox(height: 2),
              Text(
                'Orders: ${customer.totalOrders}',
                style: AppStyle.smallBlack,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
