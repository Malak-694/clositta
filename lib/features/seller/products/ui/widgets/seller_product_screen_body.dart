import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/constants/style.dart';
import '../../../../../core/widgets/custom_category_selector.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/custom_search_bar.dart';
import 'product_list_widget.dart';

class SellerProductScreenBody extends StatefulWidget {
  const SellerProductScreenBody({super.key});

  @override
  State<SellerProductScreenBody> createState() =>
      _SellerProductScreenBodyState();
}

class _SellerProductScreenBodyState extends State<SellerProductScreenBody> {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  final TextEditingController searchController = TextEditingController();

  String _selectedStockLevel = 'All';
  final List<String> _stockLevels = [
    'All',
    'Active',
    'Low Stock',
    'Out of Stock',
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_performSearch);

    // ✅ Load products as soon as this screen is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SellerProductsCubit>().getProducts();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _getStatus(int stock) {
    if (stock == 0) return 'Out of Stock';
    if (stock < 200) return 'Low Stock';
    return 'Active';
  }

  void _performSearch() {
    final query = searchController.text.toLowerCase();

    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final stockStatus = _getStatus(product.stock);
        final stockMatch =
            _selectedStockLevel == 'All' || stockStatus == _selectedStockLevel;

        if (query.isEmpty) {
          return stockMatch;
        } else {
          final nameMatch = product.name.toLowerCase().contains(query);
          final statusMatch = stockStatus.toLowerCase().contains(query);
          return stockMatch && (nameMatch || statusMatch);
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellerProductsCubit, SellerProductsState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            // ✅ Guard the cast instead of assuming it's always correct.
            if (data is List<ProductModel>) {
              setState(() {
                _allProducts = data;
              });
              _performSearch();
            }
          },
        );
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            kHorizontalPadding,
            0,
            kHorizontalPadding,
            0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${_filteredProducts.length} Products",
                    style: AppStyle.medPrimery,
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              CustomSearchBar(
                searchController: searchController,
                onSearch: (value) {
                  _performSearch();
                },
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomCategorySelector(
                      categories: _stockLevels,
                      selectedCategory: _selectedStockLevel,
                      onCategorySelected: (category) {
                        setState(() {
                          _selectedStockLevel = category;
                        });
                        _performSearch();
                      },
                      selectedColor: AppColors.ternary,
                      unselectedColor: AppColors.lightsecondary,
                      selectedTextColor: AppColors.background,
                      unselectedTextColor: AppColors.darkPrimary,
                    ),
                  ),
                  SizedBox(width: 7.h),
                  CustomElevatedButton(
                    value: "Add",
                    onPressed: () async {
                      // ✅ await + explicit refresh as a safety net,
                      // in case the cubit isn't shared across routes.
                      await Navigator.pushNamed(context, "added_product_item");
                      if (context.mounted) {
                        context.read<SellerProductsCubit>().getProducts();
                      }
                    },
                    height: 35.h,
                    width: 75.w,
                    background: AppColors.primery,
                    style: AppStyle.medBackground.copyWith(fontSize: 13.sp),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              state.maybeWhen(
                loading: () =>
                    Expanded(child: Center(child: CircularProgressIndicator())),
                fail: (error) =>
                    Expanded(child: Center(child: Text('Error: $error'))),
                success: (data) => Expanded(
                  child: ProductList(filteredProducts: _filteredProducts),
                ),
                orElse: () => _filteredProducts.isNotEmpty
                    ? Expanded(
                        child: ProductList(filteredProducts: _filteredProducts),
                      )
                    : Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
