import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/widgets/custom_category_selector.dart';
import 'package:chicora/core/widgets/filter_side_bar_widget.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_page_ui_model.dart';
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

class BuyerProductScreenBody extends StatefulWidget {
  const BuyerProductScreenBody({super.key});

  @override
  State<BuyerProductScreenBody> createState() => _BuyerProductScreenBodyState();
}
class _BuyerProductScreenBodyState extends State<BuyerProductScreenBody> {
  final List<String> _categories = [
    'All', 'top', 'bottom', 'dress', 'shoes', 'accessories', 'jacket', 'scarf',
  ];
  String? _token;
  // ignore: unused_field
  String? _userRole;
  bool _typeFilterTouchedByUser = false;

  String _selectedCategory = 'All';
  PriceSortOrder _priceSort = PriceSortOrder.none;
  String? _selectedGender;
  String? _selectedSeason;
  String? _selectedOccasion;
  String? _selectedType;

  bool _isSearchActive = false;

  final TextEditingController searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _searchImagePath;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initAndLoad();
    });
  }

  void _onScroll() {
    if (_isSearchActive) return; // don't paginate search results
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<ViewProductsCubit>().loadMore();
    }
  }

  Future<void> _initAndLoad() async {
    final prefs = getIt<SharedPrefHelper>();
    final token = await prefs.getSecureData('token');
    final roleVal = await prefs.getSecureData(SharedPrefKey.role);
    final String? userRole = roleVal;
    final effectiveType = userRole == 'tailor' ? 'Material' : 'Clothes';

    setState(() {
      _token = token;
      _userRole = userRole;
      if (!_typeFilterTouchedByUser) {
        _selectedType = effectiveType;
      }
    });

    if (_token != null) {
      context.read<ViewProductsCubit>().getProductsBuyer(
        token: _token!,
        type: _selectedType,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _clearSearchImage() {
    setState(() {
      _searchImagePath = null;
      _isSearchActive = false;
    });
    if (_token == null) return;
    context.read<ViewProductsCubit>().getProductsBuyer(
      token: _token!,
      category: _selectedCategory == 'All' ? null : _selectedCategory,
      type: _selectedType,
      season: _selectedSeason,
      occasion: _selectedOccasion,
      gender: _selectedGender,
    );
  }

  void _onTextSearch(String value) {
    final q = value.trim();
    if (_token == null) return;

    if (_searchImagePath != null) {
      setState(() => _searchImagePath = null);
    }

    if (q.isEmpty) {
      setState(() => _isSearchActive = false);
      context.read<ViewProductsCubit>().getProductsBuyer(
        token: _token!,
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        type: _selectedType,
        season: _selectedSeason,
        occasion: _selectedOccasion,
        gender: _selectedGender,
      );
      return;
    }

    setState(() => _isSearchActive = true);
    context.read<ViewProductsCubit>().searchByText(query: q);
  }

  List<ProductModelBuyer> _sortProducts(List<ProductModelBuyer> products) {
    if (_priceSort == PriceSortOrder.none) return products;
    final sorted = [...products];
    switch (_priceSort) {
      case PriceSortOrder.lowToHigh:
        sorted.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
      case PriceSortOrder.highToLow:
        sorted.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
      case PriceSortOrder.none:
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
      setState(() {
        _searchImagePath = picked.path;
        _isSearchActive = true;
      });
      context.read<ViewProductsCubit>().searchByImage(imagePath: picked.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kHorizontalPadding, 0, kHorizontalPadding, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          CustomSearchBar(
            searchController: searchController,
            onSearch: _onTextSearch,
            onImageSearch: _onImageSearch,
            searchImagePath: _searchImagePath,
            onClearSearchImage: _clearSearchImage,
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
                _searchImagePath = null;
                _isSearchActive = false;
              });

              if (_token != null) {
                context.read<ViewProductsCubit>().getProductsBuyer(
                  token: _token!,
                  category: category == 'All' ? null : category,
                  type: _selectedType,
                  season: _selectedSeason,
                  occasion: _selectedOccasion,
                  gender: _selectedGender,
                );
              }
            },
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: _openFilterSidebar,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primery.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_list, color: AppColors.primery, size: 20.sp),
                    SizedBox(width: 6.w),
                    Text('Filter & Sort', style: AppStyle.smallBlack),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: BlocBuilder<ViewProductsCubit, ViewProductsState<ProductPageData>>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox(),
                  loading: () => Center(
                    child: CircularProgressIndicator(color: AppColors.darkprimery),
                  ),
                  success: (data) {
                    final sortedProducts = _sortProducts(data.products);
                    if (sortedProducts.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.storefront_outlined, size: 56.sp, color: AppColors.light),
                              SizedBox(height: 16.h),
                              Text('No products found', textAlign: TextAlign.center, style: AppStyle.body6),
                              SizedBox(height: 8.h),
                              Text(
                                'Try another category, search term, or image.',
                                textAlign: TextAlign.center,
                                style: AppStyle.medLight.copyWith(fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        PinterestGrid<ProductModelBuyer>(
                          controller: _scrollController,
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
                              context.read<CartCubit>().addToCart(product.pId!, 1);
                            },
                          ),
                        ),
                        if (data.isLoadingMore)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.darkprimery),
                            ),
                          ),
                      ],
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

  Future<void> _openFilterSidebar() async {
    final result = await showFilterSidebar(
      context,
      initialPriceSort: _priceSort,
      initialGender: _selectedGender,
      initialSeason: _selectedSeason,
      initialOccasion: _selectedOccasion,
      initialType: _selectedType,
      useType: true,
    );
    if (result == null) return;
    setState(() {
      _priceSort = result.priceSort;
      _selectedGender = result.gender;
      _selectedSeason = result.season;
      _selectedOccasion = result.occasion;
      _selectedType = result.type;
      _typeFilterTouchedByUser = true;
    });

    if (_token == null) return;
    context.read<ViewProductsCubit>().getProductsBuyer(
      token: _token!,
      category: _selectedCategory == 'All' ? null : _selectedCategory,
      season: _selectedSeason,
      occasion: _selectedOccasion,
      type: _selectedType,
      gender: _selectedGender,
    );
  }
}