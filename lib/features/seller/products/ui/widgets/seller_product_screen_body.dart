import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/constants/style.dart';
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

  @override
  void initState() {
    super.initState();
    searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _getStatus(int stock) {
    if (stock == 0) return 'Out of Stock';
    if (stock < 300) return 'Low Stock';
    return 'Active';
  }

  void _performSearch() {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredProducts = List.from(_allProducts);
      });
    } else {
      setState(() {
        _filteredProducts = _allProducts.where((product) {
          final nameMatch = product.name.toLowerCase().contains(query);
          final statusMatch = _getStatus(
            product.stock,
          ).toLowerCase().contains(query);
          return nameMatch || statusMatch;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellerProductsCubit, SellerProductsState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            setState(() {
              _allProducts = data as List<ProductModel>;
              _filteredProducts = List.from(_allProducts);
            });
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_filteredProducts.length} Products",
                    style: AppStyle.medPrimery.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = AppColors.darkprimery,
                    ),
                  ),
                  CustomElevatedButton(
                    value: "+ Product ",
                    onPressed: () {
                      Navigator.pushNamed(context, "added_product_item");
                    },
                    height: 40.h,
                    width: 190.w,
                    background: AppColors.ternary,
                  ),
                ],
              ),
              CustomSearchBar(
                searchController: searchController,
                onSearch: (value) {
                  // run local filtering on press
                  _performSearch();
                },
              ),
              state.maybeWhen(
                loading: () => const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
                fail: (error) =>
                    Expanded(child: Center(child: Text('Error: $error'))),
                success: (data) =>
                    ProductList(filteredProducts: _filteredProducts),
                orElse: () => _filteredProducts.isNotEmpty
                    ? ProductList(filteredProducts: _filteredProducts)
                    : const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      ),
              ),
              SizedBox(height: 24.w),
            ],
          ),
        );
      },
    );
  }
}
