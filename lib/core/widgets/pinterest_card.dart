import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
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

Widget buildPinterestCard(Map<String, dynamic> product , VoidCallback onTap) {
  final name = product['name'] as String;
  final rating = product['rating'] as double;
  final imageUrl = product['image'] as String;
  final price = product['price'] as double;

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
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
    
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppStyle.body6),
                _buildStarRating(rating),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}/eg',
                      style: AppStyle.body6.copyWith(
                        fontSize: 12.sp,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = .4
                          ..color = AppColors.primery,
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 24,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF5E50B6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
    
                // Text('\$$price/yd', style: const TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
