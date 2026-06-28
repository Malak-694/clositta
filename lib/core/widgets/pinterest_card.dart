import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/pinterest_grid_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildPinterestCard(
    PinterestCardConfig config,
    VoidCallback onTap, {
      Color mainColor = AppColors.primery,
      Color darkColor = AppColors.darkprimery,
    }) {
  if (config.showStatus) {
    return _buildPostCard(config, onTap, mainColor: mainColor);
  }
  return _buildProductCard(
    config,
    onTap,
    mainColor: mainColor,
    darkColor: darkColor,
  );
}

// ── POST CARD ────────────────────────────────────────────
Widget _buildPostCard(
    PinterestCardConfig config,
    VoidCallback onTap, {
      Color mainColor = AppColors.primery,
    }) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
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
                ? Image.network(
              config.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, _, _) => Container(
                height: 120,
                color: Colors.grey.shade100,
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            )
                : Container(
              height: 120,
              color: Colors.grey.shade100,
              child: const Center(
                child: Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        config.name ?? '',
                        style: AppStyle.smallBlack,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (config.showStatus && config.status != null) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(config.status!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          config.status!,
                          style: AppStyle.smallBackground.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    if (config.showPrice && config.price != null)
                      Text(
                        '\$${config.price}',
                        style: AppStyle.medTernary.copyWith(fontSize: 17.sp),
                      ),
                    const Spacer(),
                    if (config.showEdit && config.onEdit != null)
                      IconButton(
                        onPressed: config.onEdit,
                        icon: Icon(Icons.edit, color: mainColor),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 25,
                      ),
                    if (config.showDelete && config.onDelete != null)
                      IconButton(
                        onPressed: config.onDelete,
                        icon: const Icon(Icons.delete_outline, color: AppColors.ternary),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 25,
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

// ── PRODUCT CARD ─────────────────────────────────────────
Widget _buildStarRating(double rating) {
  return Row(
    children: [
      const Icon(Icons.star, color: Colors.amber, size: 16),
      Text('$rating', style: AppStyle.medGray.copyWith(fontSize: 14.sp)),
    ],
  );
}

Widget _buildProductCard(
    PinterestCardConfig config,
    VoidCallback onTap, {
      Color mainColor = AppColors.primery,
      Color darkColor = AppColors.darkprimery,
    }) {
  final bool hasBottomRow =
      config.showPrice ||
          config.showCart ||
          (config.showEdit && config.onEdit != null) ||
          (config.showDelete && config.onDelete != null);

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
                ? Image.network(
              config.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, _, _) => Container(
                height: 120,
                color: Colors.grey.shade100,
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            )
                : Container(
              height: 120,
              color: Colors.grey.shade100,
              child: const Center(
                child: Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (config.name != null)
                  Text(
                    config.name!,
                    style: AppStyle.medBlack.copyWith(fontSize: 18.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (config.showRating && config.rating != null) ...[
                  SizedBox(height: 4.h),
                  _buildStarRating(config.rating!),
                ],
                if (hasBottomRow) ...[
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (config.showPrice && config.price != null)
                        Text(
                          '\$${config.price!.toStringAsFixed(2)}/eg',
                          style: AppStyle.smallPrimery.copyWith(fontSize: 15.sp),
                        ),
                      const Spacer(),
                      if (config.showEdit && config.onEdit != null) ...[
                        IconButton(
                          onPressed: config.onEdit,
                          icon: Icon(Icons.edit, color: mainColor),
                          padding: EdgeInsets.zero,
                          iconSize: 22,
                        ),
                      ],
                      if (config.showDelete && config.onDelete != null) ...[
                        IconButton(
                          onPressed: config.onDelete,
                          icon: const Icon(Icons.delete_outline, color: AppColors.ternary),
                          padding: EdgeInsets.zero,
                          iconSize: 22,
                        ),
                      ],
                      if (config.showCart)
                        GestureDetector(
                          onTap: config.onTap,
                          child: Container(
                            width: 36,
                            height: 24,
                            decoration: ShapeDecoration(
                              color: mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'open':
      return const Color.fromARGB(255, 108, 96, 184);
    case 'active':
      return const Color.fromARGB(255, 139, 203, 141);
    case 'pending':
      return const Color.fromARGB(255, 235, 187, 115);
    case 'closed':
      return const Color.fromARGB(255, 254, 112, 102);
    default:
      return Colors.grey;
  }
}