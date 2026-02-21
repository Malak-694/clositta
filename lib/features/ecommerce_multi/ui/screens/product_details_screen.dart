import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/labeled_text_field.dart';
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
import '../../data/models/rating models/rating_response_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModelBuyer product;
  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

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

  late List<String> productPhotos;

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
    if (!mounted) return;
    setState(() {
      _userId = id;
      if (_userId != null) {
        final matches = _ratings.where((r) => r.user == _userId);
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
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Product Detail", leading: true),
      body: BlocListener<RateProductsCubit, RateProductsState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              // deletion returns a MessageModel
              if (data is MessageModel) {
                
                // remove user's rating locally and show rate widget again
                setState(() {
                  _ratings.removeWhere((r) => r.user == _userId);
                  _userHasRated = false;
                  _userRatingModel = null;
                });
              }
              // if success with rating response, nothing to do here (onRated handles UI)
            },
            fail: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('please try again later ', style: AppStyle.smallBackground), backgroundColor: Colors.red));
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
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 350),
                      child: Image.network(
                        productPhotos[_selectedPhotoIndex],
                        key: ValueKey(_selectedPhotoIndex),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        cacheWidth: 800,
                        cacheHeight: 680,

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Photo Thumbnails
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productPhotos.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedPhotoIndex;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPhotoIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primery
                                    : Colors.grey[300]!,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                productPhotos[index],
                                key: ValueKey(index),
                                fit: BoxFit.cover,
                                width: 70,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
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
                const SizedBox(height: 24),
                // Product Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name ?? 'Unknown Product',
                      style: AppStyle.headline1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.category ?? 'Uncategorized',
                      style: AppStyle.medPrimery,
                    ),
                  ],
                ),

                SizedBox(height: 10.h),
                // Price and Rating
                Row(
                  children: [
                    Text(
                      '\$${widget.product.price ?? 0}',
                      style: AppStyle.boldSecondary.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1
                          ..color = AppColors.primery,
                      ),
                    ),
                    Spacer(),
                    CustomElevatedButton(
                      value: 'Add to Cart',
                      onPressed: () {},
                      height: 40.h,
                      width: 190.w,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.product.averageRating?.toStringAsFixed(1) ?? 0}',
                      style: AppStyle.medLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${widget.product.totalRatings ?? 0} reviews)',
                      style: AppStyle.body5,
                    ),
                  ],
                ),

                SizedBox(height: 24.h),
                // Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: AppStyle.medBlack),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.description ?? 'No description available',
                      style: AppStyle.medLight.copyWith(fontSize: 15.sp),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Seller Info
                SellerInfo(seller: widget.product.seller),

                SizedBox(height: 24.h),

                // Rating Section
                if (!_userHasRated)
                  RateProductWidget(
                    productId: widget.product.pId ?? '',
                    onRated: (r, comment) {
                      // create a temporary RatingModel and add to top of list
                      final now = DateTime.now();
                      final newRating = RatingModel(
                        user: _userId ?? '',
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
                SizedBox(height: 24.h),

                // Review Text Field
                const SizedBox(height: 12),

                const SizedBox(height: 24),
                // Customer Reviews Section
                CommentSection(
                  productComments: _ratings,
                  userRating: _userRatingModel,
                  currentUserId: _userId,
                  onDelete: (ratingId) {
                    // call cubit to delete current user's rating for this product
                    context.read<RateProductsCubit>().deleteRateProduct(
                      widget.product.pId ?? '',
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
