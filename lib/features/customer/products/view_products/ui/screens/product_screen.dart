import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/constants.dart';
import '../../../../../../core/constants/style.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController rateController = TextEditingController();
  bool isFavorite = false;
  double rating = 0;
  int _selectedPhotoIndex = 0;

  final List<String> productPhotos = [
    "https://i.pinimg.com/736x/39/b7/ca/39b7ca41eb47de1b5c472baf15c0a5b4.jpg",
    "https://i.pinimg.com/1200x/0e/fa/cc/0efaccf2ba45f5302b691aae8b083642.jpg",
    "https://i.pinimg.com/736x/28/d1/c0/28d1c04834e57a477071a5102bee6648.jpg",
  ];

  // Sample comments data - replace with actual data from API
  final List<ProductComment> productComments = [
    ProductComment(
      userName: 'Sarah Anderson',
      userInitial: 'SA',
      rating: 5,
      comment:
          'Amazing quality and perfect fit! The fabric is so comfortable for summer.',
      timestamp: '2 days ago',
    ),
    ProductComment(
      userName: 'Emma Wilson',
      userInitial: 'EW',
      rating: 4,
      comment:
          'Great product but arrived a bit late. Still very satisfied with the purchase.',
      timestamp: '1 week ago',
    ),
    ProductComment(
      userName: 'Jessica Chen',
      userInitial: 'JC',
      rating: 5,
      comment: 'Exceeded my expectations! Highly recommend to everyone.',
      timestamp: '2 weeks ago',
    ),
    ProductComment(
      userName: 'Lisa Martinez',
      userInitial: 'LM',
      rating: 3,
      comment:
          'Good product overall, but the color was slightly different from the photos.',
      timestamp: '3 weeks ago',
    ),
  ];
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
      body: SingleChildScrollView(
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
                  Text('Summer Dress', style: AppStyle.headline1),
                  const SizedBox(height: 4),
                  Text('Women', style: AppStyle.medPrimery),
                ],
              ),

              SizedBox(height: 10.h),
              // Price and Rating
              Row(
                children: [
                  Text(
                    '\$45',
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
                  Text('4.5', style: AppStyle.medLight),
                  const SizedBox(width: 4),
                  Text('(128 reviews)', style: AppStyle.body5),
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
                    'Beautiful flowing summer dress perfect for warm weather. Made from breathable cotton blend fabric.',
                    style: AppStyle.medLight.copyWith(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // Seller Info
              SellerInfo(),

              SizedBox(height: 24.h),

              // Rating Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rate This Product',
                    style: AppStyle.medBlack.copyWith(fontSize: 20.sp),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            rating = (index + 1).toDouble();
                          });
                        },
                        child: Icon(
                          Icons.star,
                          size: 32,
                          color: index < rating.toInt()
                              ? Colors.amber
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // Review Text Field
              LabeledTextField(
                hintText: 'Share your experience with us',
                hintStyle: AppStyle.medLight,
                textStyle: AppStyle.medBlack,
                controller: rateController,
              ),
              const SizedBox(height: 24),
              // Buttons
              Center(
                child: CustomElevatedButton(
                  value: 'Submit Rating',
                  onPressed: () {},
                  height: 40.h,
                  width: 200.h,
                ),
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 24),
              // Customer Reviews Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer Reviews', style: AppStyle.medBlack),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: productComments.length,
                    itemBuilder: (context, index) {
                      final comment = productComments[index];
                      return CommentCard(comment: comment);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final ProductComment comment;

  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User avatar and name
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primery,
                    child: Text(
                      comment.userInitial,
                      style: AppStyle.medBackground.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.userName, style: AppStyle.medBlack),
                      Text(comment.timestamp, style: AppStyle.medLight),
                    ],
                  ),
                ],
              ),
              // Rating stars
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < comment.rating
                        ? Colors.amber
                        : Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Comment text
          Text(
            comment.comment,
            style: AppStyle.medBlack,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class ProductComment {
  final String userName;
  final String userInitial;
  final int rating;
  final String comment;
  final String timestamp;

  ProductComment({
    required this.userName,
    required this.userInitial,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });
}

class SellerInfo extends StatelessWidget {
  const SellerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sold by', style: AppStyle.medPrimery),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Fashion Hub',
                    style: AppStyle.medBlack.copyWith(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('4.6', style: AppStyle.medLight),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey[300]!, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'View More',
              style: AppStyle.medBlack.copyWith(fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
