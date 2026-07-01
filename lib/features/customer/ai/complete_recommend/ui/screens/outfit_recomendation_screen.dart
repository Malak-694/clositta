import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/router/route_names.dart';
import '../../../../../ecommerce_multi/data/models/product_models/product_response_model.dart';
import '../../../../../ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../data/models/daily_outfit_response_model.dart';
import '../../logic/cubit/outfit_recommendation_cubit.dart';
import '../../logic/cubit/outfit_recommendation_state.dart';
import '../widgets/outfit_card.dart';

class OutfitRecomendationScreen extends StatefulWidget {
  const OutfitRecomendationScreen({super.key});

  @override
  State<OutfitRecomendationScreen> createState() =>
      _OutfitRecomendationScreenState();
}

class _OutfitRecomendationScreenState
    extends State<OutfitRecomendationScreen> {
  final List<String> occasion = [
    'Casual',
    'Formal',
    'Semi-Formal',
    'Party',
    'Sporty',
  ];
  final List<String> season = ['Summer', 'Winter', 'Spring', 'Fall'];

  String selectedOccasion = 'Casual';
  String selectedSeason = 'Summer';

  /// See the note in complete_outfit_screen.dart: this now builds a full
  /// ProductModelBuyer, since the API returns complete product data
  /// (price, stock, seller name/email, ratings summary) — not just
  /// name/category as before.
  void _openProductDetails(BuildContext context, OutfitItemModel item) {
    final info = item.product!;
    Navigator.pushNamed(
      context,
      RouteNames.product_details_screen,
      arguments: {
        'product': ProductModelBuyer(
          pId: info.id,
          name: info.name,
          description: info.description,
          price: info.price,
          stock: info.stock,
          category: info.category,
          type: info.type,
          imageUrl: info.imageUrl ?? item.imagekitUrl,
          averageRating: info.averageRating,
          totalRatings: info.totalRatings,
          ratings: const [],
        ),
        'cartCubit': getIt<CartCubit>()..getCart(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OutfitRecommendationCubit>(),
      child:
      BlocConsumer
      <OutfitRecommendationCubit,
          OutfitRecommendationState<DailyOutfitRecommendationResponse>
      >(
        listener: (context, state) {
          state.whenOrNull(
            fail: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          final outfits = state.maybeWhen(
            success: (data) => data.results.buildOutfits(),
            orElse: () => <Map<String, OutfitItemModel>>[],
          );

          return Scaffold(
            appBar: CustomAppBar(
              title: "Closet Outfit Recommendation",
              showCartIcon: false,
              onCartTap: () {},
              leading: true,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              children: [
                // ── Form card ──
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.light, width: 0.7),
                  ),
                  padding: EdgeInsets.all(15.w),
                  child: Column(
                    children: [
                      CustomDropdownList(
                        height: 49.h,
                        value: selectedOccasion,
                        items: occasion,
                        hintText: 'ex,Casual',
                        onChanged: (val) => setState(
                              () => selectedOccasion = val ?? selectedOccasion,
                        ),
                        label: 'Occasion',
                      ),
                      SizedBox(height: 15.h),
                      CustomDropdownList(
                        height: 49.h,
                        value: selectedSeason,
                        items: season,
                        hintText: 'ex,Summer',
                        onChanged: (val) => setState(
                              () => selectedSeason = val ?? selectedSeason,
                        ),
                        label: 'Season',
                      ),
                      SizedBox(height: 20.h),
                      CustomElevatedButton(
                        value: isLoading ? '...' : 'Get Recommendations',
                        onPressed: isLoading
                            ? () {}
                            : () {
                          context
                              .read<OutfitRecommendationCubit>()
                              .getRecommendation(
                            occasion: selectedOccasion,
                            season: selectedSeason,
                          );
                        },
                        height: 50.h,
                        style: AppStyle.button.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                // ── Results section ──
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (outfits.isNotEmpty) ...[
                  Text(
                    'Recommendations',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ...List.generate(
                    outfits.length,
                        (index) {
                      final outfitMap = outfits[index]; // Map<String, OutfitItemModel>
                      return OutfitCard(
                        title: 'Outfit ${index + 1}',
                        categories: outfitMap.keys.toList(),
                        items: outfitMap.values.toList(),
                        onItemTap: (item, category) {
                          if (item.product == null) return; // closet-only item, nothing to open
                          _openProductDetails(context, item);
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}