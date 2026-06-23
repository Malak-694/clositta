import 'dart:io';

import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
import 'package:chicora/core/widgets/upload_image.dart';
import 'package:chicora/features/tailor/portfolio/data/models/portfolio_tailor_response_model.dart';
import 'package:chicora/features/tailor/portfolio/logic/cubit/portfolio_tailor_cubit.dart';
import 'package:chicora/features/tailor/portfolio/logic/cubit/portfolio_tailor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/router/route_names.dart';

class AddedItemScreen extends StatefulWidget {
  final PortfolioTailorResponseModel? item;

  const AddedItemScreen({super.key, this.item});

  @override
  State<AddedItemScreen> createState() => _AddedItemScreenState();
}

class _AddedItemScreenState extends State<AddedItemScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final List<String> categories = [
    'Tops',
    'Bottoms',
    'Shoes',
    'Accessories',
    'Formal',
  ];

  String? _selectedCategory;
  String? _selectedImagePath; // new image picked by user
  String? _existingImageUrl; // existing image from API

  bool get _isUpdate => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (_isUpdate) {
      _titleController.text = widget.item!.title ?? '';
      _descriptionController.text = widget.item!.description ?? '';
      _selectedCategory = widget.item!.category;
      _existingImageUrl = widget.item!.imageUrl;
    } else {
      _selectedCategory = categories.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PortfolioTailorCubit, PortfolioTailorState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_) => Navigator.pop(context),
          fail: (error) => _showSnackBar(error),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: _isUpdate ? "Update Item" : "Add New Item",
          leading: true,
          showCartIcon: true,
          onCartTap: () =>
              Navigator.pushNamed(context, RouteNames.tailor_cart_screen),
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
                      imagePath: _selectedImagePath, // new picked image
                      imageUrl:
                          _selectedImagePath ==
                              null // show existing only if no new image
                          ? _existingImageUrl
                          : null,
                      onTap: _pickImage,
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                LabeledTextField(
                  controller: _titleController,
                  hintText: "e.g., Navy Blazer",
                  label: "Title",
                  labelStyle: AppStyle.body6,
                  fillColor: AppColors.lightprimery,
                  filled: true,
                ),
                SizedBox(height: 15.h),
                LabeledTextField(
                  controller: _descriptionController,
                  hintText: "e.g., Custom Navy Blazer",
                  label: "Description",
                  maxLines: 3,
                  labelStyle: AppStyle.body6,
                  fillColor: AppColors.lightprimery,
                  filled: true,
                ),
                SizedBox(height: 15.h),
                CustomDropdownList(
                  label: "Category",
                  value: _selectedCategory,
                  items: categories,
                  hintText: "Select category",
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value),
                ),
                SizedBox(height: 30.h),
                BlocBuilder<PortfolioTailorCubit, PortfolioTailorState>(
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
                      value: _isUpdate ? "Update Item" : "Add Item",
                      onPressed: _submitPost,
                      height: 48,
                      width: 380,
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
    if (_titleController.text.trim().isEmpty) {
      _showSnackBar('Please enter a title');
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showSnackBar('Please enter a description');
      return;
    }
    // ✅ image required only for add, optional for update
    if (!_isUpdate && _selectedImagePath == null) {
      _showSnackBar('Please select an image');
      return;
    }

    if (_isUpdate) {
      context.read<PortfolioTailorCubit>().updatePortfolioItem(
        itemId: widget.item!.id!,
        title: _titleController.text.trim(),
        category: _selectedCategory ?? categories.first,
        description: _descriptionController.text.trim(),
        imagePath: _selectedImagePath,
      );
    } else {
      context.read<PortfolioTailorCubit>().addPortfolioItem(
        title: _titleController.text.trim(),
        category: _selectedCategory ?? categories.first,
        description: _descriptionController.text.trim(),
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
