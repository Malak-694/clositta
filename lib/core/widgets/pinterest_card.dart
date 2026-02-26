import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/pinterest_grid_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget _buildStarRating(double rating) {
  return Row(
    children: [
      Icon(Icons.star, color: Colors.amber, size: 16),
      Text(
        '$rating',
        style: AppStyle.body6.copyWith(
          fontSize: 12.sp,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = .4
            ..color = AppColors.primery,
        ),
      ),
    ],
  );
}

// core/widgets/pinterest_card.dart

Widget buildPinterestCard(
  PinterestCardConfig config,
  VoidCallback onTap, {
  Color mainColor = AppColors.primery,
  Color darkColor = AppColors.darkprimery,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey.shade200)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: config.imageUrl != null
                ? Image.network(config.imageUrl!, fit: BoxFit.cover)
                : const SizedBox(height: 120),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (config.name != null)
                  Text(config.name!, style: AppStyle.body6),
                if (config.showRating && config.rating != null)
                  _buildStarRating(config.rating!),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (config.showPrice && config.price != null)
                      Text(
                        '\$${config.price!.toStringAsFixed(2)}/eg',
                        style: AppStyle.body6.copyWith(
                          fontSize: 12.sp,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = .4
                            ..color = mainColor,
                        ),
                      ),
                    Spacer(),
                    if (config.showEdit && config.onEdit != null) ...[
                      IconButton(
                        onPressed: config.onEdit,
                        icon: Icon(Icons.edit, color: mainColor),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 20,
                      ),
                      const SizedBox(width: 4),
                    ],
                    GestureDetector(
                      onTap: config.onTap,
                      child: Container(
                        width: 36,
                        height: 24,
                        decoration: ShapeDecoration(
                          color:mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(
                          config.showCart ? Icons.shopping_cart : Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
