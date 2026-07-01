import 'dart:io';
import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/router/route_names.dart';

import '../../../../../../core/widgets/upload_image.dart';
import '../../../../../ecommerce_multi/data/models/product_models/product_response_model.dart';
import '../../../../../ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../data/models/complete_outfit_request_model.dart';
import '../../data/models/complete_outfit_response_model.dart';
import '../../data/models/daily_outfit_response_model.dart';
import '../../logic/complete_outfit_cubit/complete_outfit_cubit.dart';
import '../../logic/complete_outfit_cubit/complete_outfit_state.dart';
import '../widgets/category_selector.dart';
import '../widgets/outfit_card.dart';


class CompleteOutfitScreen extends StatefulWidget {
  const CompleteOutfitScreen({super.key});

  @override
  State<CompleteOutfitScreen> createState() => _CompleteOutfitScreenState();
}

class _CompleteOutfitScreenState extends State<CompleteOutfitScreen> {
  final List<String> categoryOptions = [
    'Top', 'Bottom', 'Jacket', 'Chemise', 'Blazer', 'Dress', 'Shoes', 'Accessories',
  ];
  final List<String> occasionOptions = ['Casual', 'Formal', 'Semi-Formal', 'Party', 'Sporty'];
  final List<String> seasonOptions = ['Summer', 'Winter', 'Spring', 'Fall']; // 'all' is backend-only, intentionally excluded
  final List<String> colorOptions = [
    'White', 'Black', 'Beige', 'Red', 'Soft Blue', 'Hot Blue', 'Green', 'Yellow',
    'Orange', 'Gold', 'Grey', 'Soft Pink', 'Hot Pink', 'Purple', 'Other',
  ];
  final List<String> genderOptions = ['Female', 'Male', 'Unisex'];

  final Set<String> selectedCategories = {};
  String selectedOccasion = 'Casual';
  String selectedSeason = 'Summer';
  String selectedColor = 'Black';
  String selectedGender = 'Female';
  String? imagePath;

  String _toBackendValue(String display) =>
      display.toLowerCase().replaceAll(' ', '-');

  /// Capitalizes the first letter of a category key for display
  /// (e.g. "top" -> "Top", "bottom" -> "Bottom").
  String _formatCategoryTitle(String category) {
    if (category.isEmpty) return category;
    return category[0].toUpperCase() + category.substring(1);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imagePath = picked.path);
  }

  bool _validateRequiredFields(BuildContext context) {
    final missing = <String>[];
    if (imagePath == null) missing.add('a photo of the item');
    if (selectedCategories.isEmpty) missing.add('at least one category');
    if (selectedGender.isEmpty) missing.add('gender');

    if (missing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide ${missing.join(', ')}.')),
      );
      return false;
    }
    return true;
  }

  void _openProductDetails(BuildContext context, OutfitItemModel item) {
    final info = item.product!;
    Navigator.pushNamed(
      context,
      RouteNames.product_details_screen,
      arguments: {
        'product': ProductModelBuyer(
          pId: info.id,
          name: info.name,
          description: info.description,
          price: info.price,
          stock: info.stock,
          category: info.category,
          type: info.type,
          imageUrl: info.imageUrl ?? item.imagekitUrl,
          averageRating: info.averageRating,
          totalRatings: info.totalRatings,
          ratings: const [],

        ),
        'cartCubit': getIt<CartCubit>()..getCart(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CompleteOutfitCubit>(),
      child: BlocConsumer<CompleteOutfitCubit, CompleteOutfitState<CompleteOutfitResponseModel>>(
        listener: (context, state) {
          state.whenOrNull(
            fail: (message) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
            },
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

          // Get category -> items map directly from the response
          // instead of flattening into combined "outfits".
          final categoryResults = state.maybeWhen(
            success: (data) => data.results,
            orElse: () => <String, List<OutfitItemModel>>{},
          );

          return Scaffold(
            appBar: CustomAppBar(
              title: "Complete Outfit",
              showCartIcon: false,
              onCartTap: () {},
              leading: true,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              children: [
                // ── Form card ──
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.light, width: 0.7),
                  ),
                  padding: EdgeInsets.all(15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RequiredLabel('Item Photo'),
                      SizedBox(height: 8.h),
                      ImageUploadWidget(
                        imagePath: imagePath,
                        onTap: _pickImage,
                        onRemove: () => setState(() => imagePath = null),
                        placeholderText: 'Tap to upload your item',
                      ),
                      SizedBox(height: 20.h),

                      _RequiredLabel('Categories'),
                      SizedBox(height: 8.h),
                      CustomMultiCategorySelector(
                        categories: categoryOptions,
                        selectedCategories: selectedCategories,
                        onCategoryToggled: (cat) => setState(() {
                          selectedCategories.contains(cat)
                              ? selectedCategories.remove(cat)
                              : selectedCategories.add(cat);
                        }),
                        selectedColor: AppColors.primery,
                        unselectedColor: AppColors.light,
                      ),
                      SizedBox(height: 20.h),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomDropdownList(
                              height: 47.h,
                              value: selectedOccasion,
                              items: occasionOptions,
                              hintText: 'ex,Casual',
                              onChanged: (val) => setState(() => selectedOccasion = val ?? selectedOccasion),
                              label: 'Occasion',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomDropdownList(
                              height: 47.h,
                              value: selectedSeason,
                              items: seasonOptions,
                              hintText: 'ex,Summer',
                              onChanged: (val) => setState(() => selectedSeason = val ?? selectedSeason),
                              label: 'Season',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomDropdownList(
                              height: 47.h,
                              value: selectedColor,
                              items: colorOptions,
                              hintText: 'ex,Black',
                              onChanged: (val) => setState(() => selectedColor = val ?? selectedColor),
                              label: 'Color',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomDropdownList(
                              height: 47.h,
                              value: selectedGender,
                              items: genderOptions,
                              hintText: 'ex,Female',
                              onChanged: (val) => setState(() => selectedGender = val ?? selectedGender),
                              label: 'Gender',
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      CustomElevatedButton(
                        value: isLoading ? '...' : 'Get Recommendations',
                        onPressed: isLoading
                            ? () {}
                            : () {
                          if (!_validateRequiredFields(context)) return;
                          context.read<CompleteOutfitCubit>().getCompleteOutfit(
                            imagePath: imagePath!,
                            body: CompleteOutfitRequestModel(
                              occasion: _toBackendValue(selectedOccasion),
                              season: _toBackendValue(selectedSeason),
                              color: _toBackendValue(selectedColor),
                              gender: _toBackendValue(selectedGender),
                              categories: selectedCategories
                                  .map(_toBackendValue)
                                  .toList(),
                            ),
                          );
                        },
                        height: 50.h,
                        style: AppStyle.button.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                // ── Results grouped by category ──
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (categoryResults.isNotEmpty) ...[
                  Text('Recommendations', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  ...categoryResults.entries.map((entry) {
                    final category = entry.key;   // e.g. "top", "bottom", "shoes"
                    final items = entry.value;    // List<OutfitItemModel> for that category

                    if (items.isEmpty) return const SizedBox.shrink();

                    return OutfitCard(
                      title: _formatCategoryTitle(category),
                      categories: List.filled(items.length, category),
                      items: items,
                      onItemTap: (item, cat) {
                        if (item.product == null) return; // closet-only item, nothing to open
                        _openProductDetails(context, item);
                      },
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Renders a field label with a red trailing asterisk to mark it as required.
class _RequiredLabel extends StatelessWidget {
  final String text;
  const _RequiredLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppStyle.body5,
        children: [
          TextSpan(text: text),
          const TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}