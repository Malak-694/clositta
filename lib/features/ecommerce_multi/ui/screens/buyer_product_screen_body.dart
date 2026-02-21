import 'package:chicora/core/constants/colors.dart';
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
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      final q = searchController.text;
      if (_token != null) {
        context.read<ViewProductsCubit>().getProductsBuyer(
          token: _token!,
          search: q.isEmpty ? null : q,
        );
      }
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

  void _performSearch() {}

  Widget build(BuildContext context) {
    print('dfdfdf');

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
            onChanged: (value) {
              searchController.clear();
              _performSearch();
            },
          ),
          SizedBox(height: 20.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < _categories.length; i++) ...[
                  ElevatedButton(
                    onPressed: () {
                      final category = _categories[i];
                      setState(() {
                        _selectedCategory = category;
                        searchController
                            .clear(); // Clear search when changing category
                      });
                      if (_token != null) {
                        context.read<ViewProductsCubit>().getProductsBuyer(
                          token: _token!,
                          category: category == 'All' ? null : category,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 30),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: _selectedCategory == _categories[i]
                          ? AppColors.darkprimery
                          : AppColors.primery,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      _categories[i],
                      style: AppStyle.smallBackground,
                    ),
                  ),
                  if (i != _categories.length - 1) SizedBox(width: 5.w),
                ],
              ],
            ),
          ),

          SizedBox(height: 20.h),

          Expanded(
            child: BlocBuilder<ViewProductsCubit, ViewProductsState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (products) => PinterestGrid(
                    products: products,
                    onTap: (product) {
                      Navigator.pushNamed(
                        context,
                        RouteNames.product_details_screen,
                        arguments: {'product': product},
                      );
                    },
                  ),
                  fail: (error) => Center(child: Text(error)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
