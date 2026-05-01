import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/info_card.dart';
import 'package:chicora/core/widgets/pinterest_grid.dart';
import 'package:chicora/core/widgets/pinterest_grid_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TailorInfoScreen extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? location;
  final double? rating;
  final int? reviewCount;
  final String? email ;
  final List<Map<String, dynamic>> products;

  const TailorInfoScreen({
    super.key,
    required this.name,
    this.imageUrl,
    this.location,
    this.rating,
    this.reviewCount,
    this.email,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showCartIcon: false, onCartTap: (){} , leading: true,),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                name: name,
                imageUrl: imageUrl,
                location: location,
                rating: rating,
                reviewCount: reviewCount,
                email: email ,
              ),


              SizedBox(height: 30.h),

              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  SizedBox(width: 6.w),
                  Text("Products", style: AppStyle.medBlack),
                ],
              ),

              SizedBox(height: 12.h),

              // ── Products Grid ─────────────────────────────
              Expanded(
                child: products.isEmpty
                    ? Center(
                  child: Text(
                    "No products yet",
                    style: TextStyle(
                      color: AppColors.light,
                      fontSize: 14.sp,
                    ),
                  ),
                )
                    : PinterestGrid<Map<String, dynamic>>(
                  items: products,
                  mainColor: AppColors.secondary,
                  darkColor: AppColors.darksecondary,
                  onTap: (item) {
                    // Navigate to product details if needed
                  },
                  configBuilder: (item) => PinterestCardConfig(
                    imageUrl: item['image'],
                    name: item['name'],
                    price: item['price'],
                    rating: item['rating'],
                    showPrice: true,
                    showRating: true,
                    showCart: false,
                    showEdit: false,
                    showStatus: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}