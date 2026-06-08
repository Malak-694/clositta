import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/widgets/custom_category_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/pinterest_grid.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/widgets/pinterest_grid_config.dart';
import '../../data/models/product_models/product_response_model.dart';
import '../../logic/cart_cubit/cart_cubit.dart';
import '../../logic/view_product_logic/view_products_cubit.dart';
import '../../logic/view_product_logic/view_products_state.dart';

enum _PriceSortOrder {
  none('Default'),
  lowToHigh('Price: Low to High'),
  highToLow('Price: High to Low');

  const _PriceSortOrder(this.label);
  final String label;
}

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
    'Dress',
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
  _PriceSortOrder _priceSort = _PriceSortOrder.none;

  final TextEditingController searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
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

  void _onTextSearch(String value) {
    final q = value.trim();
    if (_token == null) return;

    if (q.isEmpty) {
      context.read<ViewProductsCubit>().getProductsBuyer(
        token: _token!,
        category: _selectedCategory == 'All' ? null : _selectedCategory,
      );
      return;
    }

    context.read<ViewProductsCubit>().searchByText(query: q);
  }

  List<ProductModelBuyer> _sortProducts(List<ProductModelBuyer> products) {
    if (_priceSort == _PriceSortOrder.none) return products;

    final sorted = List<ProductModelBuyer>.from(products);
    switch (_priceSort) {
      case _PriceSortOrder.lowToHigh:
        sorted.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
      case _PriceSortOrder.highToLow:
        sorted.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
      case _PriceSortOrder.none:
        break;
    }
    return sorted;
  }

  Future<void> _onImageSearch() async {
    if (_token == null) return;

    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null || !mounted) return;

      searchController.clear();
      context.read<ViewProductsCubit>().searchByImage(imagePath: picked.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  @override
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
          SizedBox(height: 20),
          CustomSearchBar(
            searchController: searchController,
            onSearch: _onTextSearch,
            onImageSearch: _onImageSearch,
          ),
          SizedBox(height: 20.h),
          CustomCategorySelector(
            categories: _categories,
            selectedCategory: _selectedCategory,
            selectedColor: AppColors.darkprimery,
            unselectedColor: AppColors.primery,
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

          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,

            child: DropdownButton<_PriceSortOrder>(
              isDense: true,

              value: _priceSort,
              underline: const SizedBox.shrink(),
              icon: Icon(Icons.sort, color: AppColors.primery, size: 22.sp),
              style: AppStyle.medBlack.copyWith(fontSize: 14.sp),
              items: _PriceSortOrder.values
                  .map(
                    (order) => DropdownMenuItem(
                      value: order,
                      child: Text(order.label, style: AppStyle.smallBlack),
                    ),
                  )
                  .toList(),
              selectedItemBuilder: (context) {
                return _PriceSortOrder.values.map((order) {
                  if (order == _PriceSortOrder.none) {
                    return const SizedBox.shrink();
                  }

                  return Row(
                    children: [
                      Text(order.label, style: AppStyle.smallBlack),
                      SizedBox(width: 4.w),
                    ],
                  );
                }).toList();
              },

              onChanged: (order) {
                if (order == null) return;
                setState(() => _priceSort = order);
              },
            ),
          ),

          SizedBox(height: 8.h),

          Expanded(
            child: BlocBuilder<ViewProductsCubit, ViewProductsState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox(),
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkprimery,
                    ),
                  ),
                  success: (products) {
                    final sortedProducts = _sortProducts(products);
                    return sortedProducts.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.storefront_outlined,
                                    size: 56.sp,
                                    color: AppColors.light,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No products found',
                                    textAlign: TextAlign.center,
                                    style: AppStyle.body6,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Try another category, search term, or image.',
                                    textAlign: TextAlign.center,
                                    style: AppStyle.medLight.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : PinterestGrid<ProductModelBuyer>(
                            items: sortedProducts,
                            onTap: (product) => Navigator.pushNamed(
                              context,
                              RouteNames.product_details_screen,
                              arguments: {
                                'product': product,
                                'cartCubit': context.read<CartCubit>(),
                              },
                            ),
                            configBuilder: (product) => PinterestCardConfig(
                              imageUrl: product.imageUrl,
                              name: product.name,
                              rating: product.averageRating,
                              price: product.price,
                              showCart: true,
                              onTap: () {
                                context.read<CartCubit>().addToCart(
                                  product.pId!,
                                  1,
                                );
                              },
                            ),
                          );
                  },
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
