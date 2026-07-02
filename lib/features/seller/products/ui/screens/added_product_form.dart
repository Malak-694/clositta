import 'dart:io';

import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
import 'package:chicora/core/widgets/upload_image.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddedProductForm extends StatefulWidget {
  final ProductModel? product; // null = add, not null = update

  const AddedProductForm({super.key, this.product});

  @override
  State<AddedProductForm> createState() => _AddedProductFormState();
}

class _AddedProductFormState extends State<AddedProductForm> {
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _colorController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final List<String> categories = [
    "All",
    "top",
    "bottom",
    "jacket",
    "scarf",
    "dress",
    "shoes",
    "accessories",  ];
  final List<String> types = ['Clothes', 'Material'];
  final List<String> genders = ['male', 'female', 'unisex'];
  final List<String> seasons = ['summer', 'winter', 'spring', 'autumn', 'all-season'];
  final List<String> occasions = ['casual', 'formal', 'wedding', 'sport', 'beach', 'party', 'other'];

  String? _selectedCategory;
  String? _selectedType;
  String? _selectedGender;
  String? _selectedSeason;
  String? _selectedOccasion;
  String? _selectedImagePath;
  String? _existingImageUrl;

  bool get _isUpdate => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (_isUpdate) {
      // ✅ pre-fill for update
      _productNameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _selectedCategory = categories.firstWhere(
        (c) => c.toLowerCase() == widget.product!.category.toLowerCase(),
        orElse: () => categories.first,
      );
      _selectedType = types.firstWhere(
        (t) => t.toLowerCase() == widget.product!.type.toLowerCase(),
        orElse: () => types.first,
      );
      _colorController.text = widget.product!.color ?? '';
      _selectedGender = genders.firstWhere(
        (g) => g.toLowerCase() == widget.product!.gender?.toLowerCase(),
        orElse: () => genders.first,
      );
      _selectedSeason = seasons.firstWhere(
        (s) => s.toLowerCase() == widget.product!.season?.toLowerCase(),
        orElse: () => seasons.first,
      );
      _selectedOccasion = occasions.firstWhere(
        (o) => o.toLowerCase() == widget.product!.occasion?.toLowerCase(),
        orElse: () => occasions.first,
      );
      _existingImageUrl = widget.product!.imageUrl;
    } else {
      _selectedCategory = categories.first;
      _selectedType = types.first;
      _selectedGender = genders.first;
      _selectedSeason = seasons.first;
      _selectedOccasion = occasions.first;
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SellerProductsCubit, SellerProductsState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_) => Navigator.pop(context),
          fail: (error) => _showSnackBar(error),
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: _isUpdate ? "Update Product" : "Add New Product",
          leading: true,
          showCartIcon: false,
          onCartTap: () {},
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Upload Image", style: AppStyle.body6),
                    SizedBox(height: 10.h),
                    ImageUploadWidget(
                      height: 150.h,
                      imagePath: _selectedImagePath,
                      imageUrl: _selectedImagePath == null
                          ? _existingImageUrl
                          : null, // ✅
                      onTap: _pickImage,
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                LabeledTextField(
                  controller: _productNameController,
                  hintText: "e.g., Wedding Dress",
                  label: "Name",
                  labelStyle: AppStyle.body6,
                  fillColor: AppColors.lightprimery,
                  filled: true,
                ),
                SizedBox(height: 15.h),
                LabeledTextField(
                  controller: _descriptionController,
                  hintText: "Describe your product...",
                  maxLines: 3,
                  label: "Description",
                  labelStyle: AppStyle.body6,
                  fillColor: AppColors.lightprimery,
                  filled: true,
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      child: LabeledTextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        hintText: "00.0",
                        label: 'Price (\$)',
                        labelStyle: AppStyle.body6,
                        fillColor: AppColors.lightprimery,
                        filled: true,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: LabeledTextField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        hintText: "0",
                        label: "Stock",
                        labelStyle: AppStyle.body6,
                        fillColor: AppColors.lightprimery,
                        filled: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdownList(
                        label: "Category",
                        value: _selectedCategory,
                        items: categories,
                        hintText: "Select category",
                        onChanged: (value) =>
                            setState(() => _selectedCategory = value),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomDropdownList(
                        label: "Type",
                        value: _selectedType,
                        items: types,
                        hintText: "Select type",
                        onChanged: (value) =>
                            setState(() => _selectedType = value),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdownList(
                        label: "Gender",
                        value: _selectedGender,
                        items: genders,
                        hintText: "Select gender",
                        onChanged: (value) =>
                            setState(() => _selectedGender = value),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomDropdownList(
                        label: "Season",
                        value: _selectedSeason,
                        items: seasons,
                        hintText: "Select season",
                        onChanged: (value) =>
                            setState(() => _selectedSeason = value),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdownList(
                        label: "Occasion",
                        value: _selectedOccasion,
                        items: occasions,
                        hintText: "Select occasion",
                        onChanged: (value) =>
                            setState(() => _selectedOccasion = value),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: LabeledTextField(
                        controller: _colorController,
                        hintText: "e.g., Red",
                        label: "Color",
                        labelStyle: AppStyle.body6,
                        fillColor: AppColors.lightprimery,
                        filled: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                BlocBuilder<SellerProductsCubit, SellerProductsState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );

                    if (isLoading) {
                      return SizedBox(
                        height: 48.h,
                        width: 380.w,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primery.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      );
                    }

                    return CustomElevatedButton(
                      value: _isUpdate ? "Update Product" : "Add Product",
                      onPressed: _submitPost,
                      height: 48,
                      width: 380,
                      background: AppColors.primery,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitPost() {
    if (_productNameController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _stockController.text.trim().isEmpty) {
      _showSnackBar('Please enter all fields');
      return;
    }
    // ✅ image required only for add
    if (!_isUpdate && _selectedImagePath == null) {
      _showSnackBar('Please select an image');
      return;
    }

    if (_isUpdate) {
      context.read<SellerProductsCubit>().updateProduct(
        productId: widget.product!.id,
        name: _productNameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: _priceController.text.trim(),
        stock: _stockController.text.trim(),
        category: _selectedCategory ?? categories.first,
        type: _selectedType ?? types.first,
        gender: _selectedGender ?? genders.first,
        season: _selectedSeason ?? seasons.first,
        occasion: _selectedOccasion ?? occasions.first,
        color: _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
        imagePath: _selectedImagePath, // ✅ null if not changed
      );
    } else {
      context.read<SellerProductsCubit>().addProduct(
        name: _productNameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: _priceController.text.trim(),
        stock: _stockController.text.trim(),
        category: _selectedCategory ?? categories.first,
        type: _selectedType ?? types.first,
        gender: _selectedGender ?? genders.first,
        season: _selectedSeason ?? seasons.first,
        occasion: _selectedOccasion ?? occasions.first,
        color: _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
        imagePath: _selectedImagePath!,
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStyle.userMessage(message), style: AppStyle.body6),
        backgroundColor: AppColors.lightsecondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();

        if (fileSize > 5 * 1024 * 1024) {
          if (mounted) _showSnackBar('Image size must be less than 5MB');
          return;
        }

        setState(() => _selectedImagePath = pickedFile.path);
      }
    } catch (e) {
      if (mounted) _showSnackBar('Failed to pick image: $e');
    }
  }
}
