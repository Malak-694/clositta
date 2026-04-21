import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/router/route_names.dart';

String _getStatus(int stock) {
  if (stock == 0) return 'Out of Stock';
  if (stock < 200) return 'Low Stock';
  return 'Active';
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'Active':
      return Colors.green;
    case 'Low Stock':
      return Colors.orange;
    case 'Out of Stock':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

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

Widget buildProductCard(BuildContext context, ProductModel product) {
  final name = product.name;
  final rating = product.averageRating;
  final pricePerYard = product.price;
  final stock = product.stock;
  final status = _getStatus(stock);
  final imageUrl = product.imageUrl;

  return Container(
    height: 135.h,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.all(16.h),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            imageUrl,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100.w,
                height: 100.h,
                color: Colors.grey[200],
                child: Icon(Icons.error, color: Colors.grey),
              );
            },
          ),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120.w,
              child: Text(
                name,
                style: AppStyle.medBlack.copyWith(
                  fontSize: 14.sp,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = .5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                _buildStarRating(rating),
                SizedBox(width: 8.w),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              '£$pricePerYard/Meter',
              style: AppStyle.medPrimery.copyWith(
                fontSize: 16.sp,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = .4
                  ..color = AppColors.ternary,
              ),
            ),
            Text(
              'Stock: $stock',
              style: AppStyle.body6.copyWith(
                fontSize: 12.sp,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = .4
                  ..color = AppColors.primery,
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(status), width: 1),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w500,
                    fontSize:
                        12, // Adjusted font size as it seemed hardcoded in original
                  ),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            content: Text(
                              'Are you sure you want to Delete this product?',
                              style: AppStyle.medBlack.copyWith(fontSize: 16.sp),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: Text('Cancel', style: AppStyle.medBlack),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<SellerProductsCubit>()
                                      .deleteProduct(product.id);
                                  Navigator.pop(dialogContext);
                                },
                                child: Text('Delete', style: AppStyle.medTernary),
                              ),
                            ],
                          );
                        },
                      );// keep existing delete dialog
                    },
                    icon: Icon(Icons.delete, color: AppColors.primery),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 22,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.update_product_screen,
                        arguments: product,
                      ).then((_) {
                        context.read<SellerProductsCubit>().getProducts();
                      });
                    },
                    icon: Icon(Icons.edit, color:  AppColors.primery),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
