import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/widgets/custom_category_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/pinterest_grid.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/widgets/pinterest_grid_config.dart';
import '../../data/models/product_models/product_response_model.dart';
import '../../logic/view_product_logic/view_products_cubit.dart';
import '../../logic/view_product_logic/view_products_state.dart';

class BuyerProductScreenBody extends StatefulWidget {
  const BuyerProductScreenBody({super.key});

  @override
  State<BuyerProductScreenBody> createState() => _BuyerProductScreenBodyState();
}

class _BuyerProductScreenBodyState extends State<BuyerProductScreenBody> {
  final List<String> _categories = [
    'All',
    'Tops',
    'Bottoms',
    'Dresses',
    'Shoes',
    'Outwear',
    'Accessories',
    'Women',
    'Men',
    'Kids',
    'Others',
  ];
  // local token for API calls
  String? _token;
  String _selectedCategory = 'All'; // Track selected category
  // role-aware primary color (defaults to app default)
  Color _rolePrimary = AppColors.primery;
  Color _roleDark = AppColors.darkprimery;

  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // load role based primary color
    AppColors.primaryForCurrentUser().then((color) {
      if (!mounted) return;
      setState(() {
        _rolePrimary = color;
      });
    });

    AppColors.darkForCurrentUser().then((color) {
      if (!mounted) return;
      setState(() {
        _roleDark = color;
      });
    });

    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    final prefs = getIt<SharedPrefHelper>();
    final token = await prefs.getSecureData('token');
    setState(() {
      _token = token;
    });
    if (_token != null) {
      context.read<ViewProductsCubit>().getProductsBuyer(token: _token!);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kHorizontalPadding,
        0,
        kHorizontalPadding,
        0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomSearchBar(
            searchController: searchController,
            onSearch: (value) {
              final q = value.trim();
              if (_token != null) {
                context.read<ViewProductsCubit>().getProductsBuyer(
                  token: _token!,
                  search: q.isEmpty ? null : q,
                );
              }
            },
          ),
          SizedBox(height: 20.h),
          CustomCategorySelector(
            categories: _categories,
            selectedCategory: _selectedCategory,
            selectedColor: _roleDark,
            unselectedColor: _rolePrimary,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
                searchController.clear();
              });

              if (_token != null) {
                context.read<ViewProductsCubit>().getProductsBuyer(
                  token: _token!,
                  category: category == 'All' ? null : category,
                );
              }
            },
          ),

          SizedBox(height: 20.h),

          Expanded(
            child: BlocBuilder<ViewProductsCubit, ViewProductsState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (products) => PinterestGrid<ProductModelBuyer>(
                    items: products,
                    onTap: (product) => Navigator.pushNamed(
                      context,
                      RouteNames.product_details_screen,
                      arguments: {'product': product},
                    ),
                    configBuilder: (product) => PinterestCardConfig(
                      imageUrl: product.imageUrl,
                      name: product.name,
                      rating: product.averageRating,
                      price: product.price,
                      showCart: true,
                    ),
                  ),
                  fail: (error) => Center(
                    child: Text(
                      'There is a connection error, please try again later',
                      style: AppStyle.medBlack,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
