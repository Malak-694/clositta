import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helper/shared_key.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/pinterest_grid.dart';
import '../../../../core/widgets/pinterest_grid_config.dart';
import '../../data/models/product_models/product_page_ui_model.dart';
import '../../data/models/product_models/product_response_model.dart';
import '../../logic/view_product_logic/view_products_cubit.dart';
import '../../logic/view_product_logic/view_products_state.dart';

class SellerInfoScreen extends StatefulWidget {
  final String name;
  final String sellerId;
  final String? imageUrl;
  final String? location;
  final double? rating;
  final int? reviewCount;
  final String? email;

  const SellerInfoScreen({
    super.key,
    required this.name,
    required this.sellerId,
    this.imageUrl,
    this.location,
    this.rating,
    this.reviewCount,
    this.email,
  });

  @override
  State<SellerInfoScreen> createState() => _SellerInfoScreenState();
}

class _SellerInfoScreenState extends State<SellerInfoScreen> {
  late final ViewProductsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ViewProductsCubit>();
    // addPostFrameCallback avoids the async initState double-trigger issue
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadProducts();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final token =
        await getIt<SharedPrefHelper>().getSecureData(SharedPrefKey.token) ??
            '';
    if (!mounted) return;
    // Pass type: null so ALL product types for this seller are shown,
    // regardless of the user's default type filter (Clothes / Material).
    _cubit.getProductsBuyer(
      token: token,
      sellerId: widget.sellerId,
      type: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  name: widget.name,
                  imageUrl: widget.imageUrl,
                  location: widget.location,
                  rating: widget.rating,
                  reviewCount: widget.reviewCount,
                  email: widget.email,
                ),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primery,
                      size: 20,
                    ),
                    SizedBox(width: 6.w),
                    Text("Products", style: AppStyle.medBlack),
                  ],
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: BlocBuilder<ViewProductsCubit,
                      ViewProductsState<ProductPageData>>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const SizedBox(),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        success: (data) => _buildGrid(data.products),
                        fail: (message) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                message,
                                style: TextStyle(color: AppColors.light),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _loadProducts,
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildGrid(List<ProductModelBuyer> products) {
    if (products.isEmpty) {
      return Center(
        child: Text(
          "No products yet",
          style: TextStyle(color: AppColors.light, fontSize: 14.sp),
        ),
      );
    }

    return PinterestGrid<ProductModelBuyer>(
      items: products,
      mainColor: AppColors.primery,
      darkColor: AppColors.darkprimery,
      onTap: (_) {},
      configBuilder: (product) => PinterestCardConfig(
        imageUrl: product.imageUrl ?? '',
        name: product.name ?? '',
        price: product.price ?? 0,
        showPrice: true,
        showRating: true,
        showCart: true,
        showEdit: false,
        showStatus: false,
      ),
    );
  }
}
