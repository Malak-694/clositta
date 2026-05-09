import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? location;
  final String? email ;
  final double? rating;
  final int? reviewCount;

  const InfoCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.location,
    this.rating,
    this.reviewCount,
    this.email
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconButton(onPressed: (){Navigator.pop(context);},
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.lightprimery,
            backgroundImage:
            imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? Icon(Icons.person, color: AppColors.primery, size: 28)
                : null,
          ),
          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: AppStyle.medBlack),
              if (location != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 14, color: AppColors.light),
                    const SizedBox(width: 2),
                    Text(location!, style: AppStyle.medBlack),
                  ],
                ),
              ],
              // email
              if(email != null )...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.email,
                        size: 16, color: AppColors.light),
                    const SizedBox(width: 3),
                    Text(email!, style: AppStyle.body6),
                  ],
                ),
              ],
              // Rating (optional)
              if (rating != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(
                      rating!.toStringAsFixed(1),
                      style: AppStyle.medBlack,
                    ),
                    if (reviewCount != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        "(${reviewCount!} reviews)",
                        style: TextStyle(
                          color: AppColors.light,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}