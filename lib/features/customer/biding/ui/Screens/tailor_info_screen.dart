import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/style.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/info_card.dart';
import '../../../../../core/widgets/pinterest_grid.dart';
import '../../../../../core/widgets/pinterest_grid_config.dart';
import '../../data/models/portfolio_item_model.dart';
import '../../logic/cubit/portfolio_cubit/portfolio_cubit.dart';
import '../../logic/cubit/portfolio_cubit/portfolio_state.dart';

class TailorInfoScreen extends StatelessWidget {
  final String name;
  final String tailorId;
  final String? imageUrl;
  final String? location;
  final double? rating;
  final int? reviewCount;
  final String? email;

  const TailorInfoScreen({
    super.key,
    required this.name,
    required this.tailorId,
    this.imageUrl,
    this.location,
    this.rating,
    this.reviewCount,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PortfolioCubit>()..loadPortfolio(tailorId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  name: name,
                  imageUrl: imageUrl,
                  location: location,
                  rating: rating,
                  reviewCount: reviewCount,
                  email: email,
                ),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: AppColors.secondary, size: 20),
                    SizedBox(width: 6.w),
                    Text("Products", style: AppStyle.medBlack),
                  ],
                ),

                SizedBox(height: 12.h),

                Expanded(
                  child: BlocBuilder<PortfolioCubit, PortfolioState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const SizedBox(),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        fail: (msg) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(msg, style: TextStyle(color: AppColors.light)),
                              TextButton(
                                onPressed: () => context
                                    .read<PortfolioCubit>()
                                    .loadPortfolio(tailorId),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                        success: (data) {
                          final items = data as List<PortfolioItem>;
                          if (items.isEmpty) {
                            return Center(
                              child: Text("No products yet",
                                  style: TextStyle(color: AppColors.light, fontSize: 14.sp)),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: PinterestGrid<Map<String, dynamic>>(
                              items: items.map((e) => e.toGridItem()).toList(),
                              mainColor: AppColors.secondary,
                              darkColor: AppColors.darksecondary,
                              onTap: (_) {},
                              configBuilder: (item) => PinterestCardConfig(
                                imageUrl: item['image'],
                                name: item['name'],
                                // price: item['price'],
                                // rating: item['rating'],
                                showPrice: true,
                                showRating: true,
                                showCart: false,
                                showEdit: false,
                                showStatus: false,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}