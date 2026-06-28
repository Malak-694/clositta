
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';


import '../../../../../core/di/dependency_injection.dart';

import '../../../../../core/widgets/custom_app_bar.dart';

import '../../../../../core/widgets/info_card.dart';

import '../../../../../core/widgets/pinterest_grid.dart';

import '../../../../../core/widgets/pinterest_grid_config.dart';

import '../../../../ecommerce_multi/ui/widgets/comment_section_widget.dart';

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

        appBar: CustomAppBar(
          title: name,

          leading: true,

          showCartIcon: false,

          onCartTap: () {},
        ),

        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),

                child: BlocBuilder<PortfolioCubit, PortfolioState>(
                  builder: (context, state) {
                    final tailor = state.maybeWhen(
                      success: (data) {
                        final items = data as List<PortfolioItem>;

                        return items.isNotEmpty ? items[0].tailor : null;
                      },

                      orElse: () => null,
                    );
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(height: 12.h),

                        InfoCard(
                          name: tailor?.name ?? name,

                          imageUrl: tailor?.imageUrl ?? imageUrl,

                          location: tailor?.location ?? location,

                          rating: tailor?.averageRating ?? rating,

                          reviewCount: tailor?.totalRatings ?? reviewCount,

                          email: tailor?.email ?? email,
                          mapUrl: tailor?.mapsUrl,
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 20.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),

                  child: BlocBuilder<PortfolioCubit, PortfolioState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const SizedBox(),

                        loading: () =>
                            const Center(child: CircularProgressIndicator()),

                        fail: (msg) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                msg,

                                style: TextStyle(color: AppColors.light),
                              ),

                              TextButton(
                                onPressed: () => context
                                    .read<PortfolioCubit>()
                                    .loadPortfolio(tailorId),

                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),

                        success: (data) {
                          final items = data as List<PortfolioItem>;

                          if (items.isEmpty) {
                            return Center(
                              child: Text(
                                'No products yet',

                                style: TextStyle(
                                  color: AppColors.light,

                                  fontSize: 14.sp,
                                ),
                              ),
                            );
                          }

                          final ratings = items[0].tailor.ratings;

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,

                              children: [
                                PinterestGrid<Map<String, dynamic>>(
                                  shrinkWrap: true,

                                  items: items
                                      .map((e) => e.toGridItem())
                                      .toList(),

                                  mainColor: AppColors.secondary,

                                  darkColor: AppColors.darksecondary,

                                  onTap: (_) {},

                                  configBuilder: (item) => PinterestCardConfig(
                                    imageUrl: item['image'],

                                    name: item['name'],

                                    showPrice: true,

                                    showRating: true,

                                    showCart: false,

                                    showEdit: false,

                                    showStatus: false,
                                  ),
                                ),

                                if (ratings != null && ratings.isNotEmpty) ...[
                                  SizedBox(height: 24.h),

                                  CommentSection(
                                    productComments: ratings,

                                    userRating: null,

                                    currentUserId: null,

                                    accent: AppColors.lightsecondary,

                                    accentDark: AppColors.darksecondary,

                                    onDelete: null,
                                  ),

                                  SizedBox(height: 16.h),
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    },
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
