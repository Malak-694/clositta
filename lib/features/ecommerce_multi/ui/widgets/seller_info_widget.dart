import 'package:chicora/features/ecommerce_multi/data/models/product_models/seller_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/style.dart';

class SellerInfo extends StatelessWidget {
  final SellerModel? seller;
  const SellerInfo({super.key, this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sold by', style: AppStyle.medPrimery),
              const SizedBox(height: 8),
              Text(
                seller?.name ?? 'Unknown Seller',
                style: AppStyle.medBlack.copyWith(fontSize: 16),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey[300]!, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'View More',
              style: AppStyle.medBlack.copyWith(fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
