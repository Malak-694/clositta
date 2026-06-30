import 'package:chicora/features/ecommerce_multi/data/models/product_models/seller_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/router/route_names.dart';

class SellerInfo extends StatelessWidget {
  final SellerModel? seller;
  final Color accent;
  final Color accentDark;

  const SellerInfo({
    super.key,
    this.seller,
    this.accent = AppColors.primery,
    this.accentDark = AppColors.darkprimery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.lightprimery,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: accent.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.storefront_outlined,
              color: accentDark,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sold by',
                  style: AppStyle.caption.copyWith(
                    color: AppColors.light,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  seller?.name ?? 'Unknown seller',
                  style: AppStyle.body6.copyWith(
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                RouteNames.seller_info_screen,
                arguments: {
                  'name': seller?.name ?? '',
                  'sellerId': seller?.sId ?? '',
                  'email': seller?.email,
                },
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: accentDark,
              side: BorderSide(
                color: accent.withValues(alpha: 0.4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'View store',
              style: AppStyle.smallBlack.copyWith(
                fontSize: 13.sp,
                color: accentDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
