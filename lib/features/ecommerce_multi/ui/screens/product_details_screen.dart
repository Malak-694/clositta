import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/add_to_cart_section.dart';
import '../widgets/comment_section_widget.dart';
import '../widgets/rate_product_widget.dart';
import '../widgets/seller_info_widget.dart';
import '../../logic/rate_products_logic/rate_products_cubit.dart';
import '../../logic/rate_products_logic/rate_products_state.dart';
import 'package:chicora/features/seller/products/data/models/rating_model_response.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/helper/shared_key.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/models/message_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModelBuyer product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController rateController = TextEditingController();
  bool isFavorite = false;
  double rating = 0;
  int _selectedPhotoIndex = 0;
  bool _userHasRated = false;
  RatingModel? _userRatingModel;
  late List<RatingModel> _ratings;
  String? _userId;
  String? _userName;

  late List<String> productPhotos;
  Color _rolePrimary = AppColors.primery;
  Color _roleDark = AppColors.darkprimery;

  @override
  void initState() {
    super.initState();
    // Use product image URL or default fallback
    productPhotos = widget.product.imageUrl != null
        ? [widget.product.imageUrl!]
        : ['https://via.placeholder.com/400x500?text=No+Image'];
    // initialize ratings list and load current user info
    _ratings = List<RatingModel>.from(widget.product.ratings ?? []);
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = getIt<SharedPrefHelper>();
    final id = await prefs.getSecureData(SharedPrefKey.id);
    final name = await prefs.getSecureData(SharedPrefKey.name);
    if (!mounted) return;
    setState(() {
      _userId = id;
      _userName = name;
      if (_userId != null) {
        final matches = _ratings.where((r) => r.user.id == _userId);
        if (matches.isNotEmpty) {
          _userHasRated = true;
          _userRatingModel = matches.first;
        }
      }
    });
  }

  @override
  void dispose() {
    rateController.dispose();
    super.dispose();
  }

  void _showZoomedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Product Detail",
        leading: true,
        showCartIcon: false,
        onCartTap: () {},
      ),
      body: BlocListener<RateProductsCubit, RateProductsState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              // deletion returns a MessageModel
              if (data is MessageModel) {
                // remove user's rating locally and show rate widget again
                setState(() {
                  _ratings.removeWhere((r) => r.user.id == _userId);
                  _userHasRated = false;
                  _userRatingModel = null;
                });
              }
              // if success with rating response, nothing to do here (onRated handles UI)
            },
            fail: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Please try again later',
                    style: AppStyle.medBackground,
                  ),
                  backgroundColor: AppColors.ternary,
                ),
              );
            },
          );
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Gallery
                GestureDetector(
                  onTap: () => _showZoomedImage(
                    context,
                    productPhotos[_selectedPhotoIndex],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: _rolePrimary.withValues(alpha: 0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      child: Container(
                        color: AppColors.lightprimery,
                        constraints: BoxConstraints(maxHeight: 360.h),
                        child: Image.network(
                          productPhotos[_selectedPhotoIndex],
                          key: ValueKey(_selectedPhotoIndex),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          cacheWidth: 800,
                          cacheHeight: 680,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200.h,
                              color: AppColors.lightprimery,
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48.sp,
                                  color: AppColors.light,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Photo Thumbnails
                SizedBox(
                  height: 80.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productPhotos.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedPhotoIndex;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPhotoIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? _roleDark
                                    : AppColors.light.withValues(alpha: 0.4),
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                productPhotos[index],
                                key: ValueKey(index),
                                fit: BoxFit.cover,
                                width: 70.w,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.lightprimery,
                                    width: 70.w,
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      color: AppColors.light,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  widget.product.name ?? 'Unknown Product',
                  style: AppStyle.headline1,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _rolePrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    widget.product.category ?? 'Uncategorized',
                    style: AppStyle.caption.copyWith(
                      color: _rolePrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${widget.product.price ?? 0}',
                      style: AppStyle.boldSecondary.copyWith(color: _roleDark),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightsecondary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.secondary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            widget.product.averageRating?.toStringAsFixed(1) ??
                                '0',
                            style: AppStyle.body6,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '(${widget.product.totalRatings ?? 0})',
                            style: AppStyle.body5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightprimery,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: _rolePrimary.withValues(alpha: 0.12),
                    ),
                  ),
                  child: AddToCartSection(
                    productId: widget.product.pId!,
                    accent: _rolePrimary,
                    accentDark: _roleDark,
                  ),
                ),
                SizedBox(height: 28.h),
                // Description
                Text(
                  'Description',
                  style: AppStyle.body6.copyWith(
                    color: _roleDark,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  widget.product.description ?? 'No description available',
                  style: AppStyle.medLight.copyWith(
                    fontSize: 15.sp,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 24.h),
                SellerInfo(
                  seller: widget.product.seller,
                  accent: _rolePrimary,
                  accentDark: _roleDark,
                ),

                SizedBox(height: 24.h),

                // Rating Section
                if (!_userHasRated)
                  RateProductWidget(
                    productId: widget.product.pId ?? '',
                    accent: _rolePrimary,
                    accentDark: _roleDark,
                    onRated: (r, comment) {
                      // create a temporary RatingModel and add to top of list
                      final now = DateTime.now();
                      final newRating = RatingModel(
                        user: User(id: _userId ?? '', name: _userName ?? ''),
                        rating: r,
                        comment: comment,
                        id: now.toIso8601String(),
                        createdAt: now,
                        updatedAt: now,
                      );
                      setState(() {
                        _userHasRated = true;
                        _userRatingModel = newRating;
                        _ratings.insert(0, newRating);
                      });
                    },
                  ),
                SizedBox(height: 8.h),
                CommentSection(
                  productComments: _ratings,
                  userRating: _userRatingModel,
                  currentUserId: _userId,
                  accent: _rolePrimary,
                  accentDark: _roleDark,
                  onDelete: (ratingId) {
                    context.read<RateProductsCubit>().deleteRateProduct(
                      widget.product.pId ?? '',
                    );
                  },
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
