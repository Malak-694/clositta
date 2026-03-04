import 'dart:io';

import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
import 'package:chicora/core/widgets/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/closet_item_response_model.dart';
import '../../logic/cubit/closet_cubit.dart';
import '../../logic/cubit/closet_state.dart';

class AddedClosetItemScreen extends StatefulWidget {
  final ClosetItemResponseModel? item; // ✅ null = add, not null = update

  const AddedClosetItemScreen({super.key, this.item});

  @override
  State<AddedClosetItemScreen> createState() => _AddedClosetItemScreenState();
}

class _AddedClosetItemScreenState extends State<AddedClosetItemScreen> {
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<String> categories = ['Tops', 'Bottoms', 'Shoes', 'Accessories'];
  final List<String> seasons = [
    'All Season', 'Winter', 'Spring', 'Summer', 'Autumn'
  ];

  String? _selectedCategory;
  String? _selectedSeason;
  String? _selectedImagePath;
  String? _existingImageUrl;

  bool get _isUpdate => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (_isUpdate) {
      // ✅ pre-fill fields for update
      _nameController.text = widget.item!.name ?? '';
      _colorController.text = widget.item!.color ?? '';
      _selectedCategory = widget.item!.category;
      _selectedSeason = widget.item!.season;
      _existingImageUrl = widget.item!.imageUrl;
    } else {
      _selectedCategory = categories.first;
      _selectedSeason = seasons.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClosetCubit, ClosetState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_) {
             Navigator.pop(context);
          },
          fail: (error) => _showSnackBar(error),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: _isUpdate ? "Update Item" : "Add New Item",
          leading: true,
          showCartIcon: true,
          onCartTap: () => Navigator.pushNamed(
            context,
            RouteNames.customer_cart_screen,
          ),
          
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
                      imagePath: _selectedImagePath,
                      imageUrl: _selectedImagePath == null
                          ? _existingImageUrl
                          : null, // ✅ show existing if no new image
                      onTap: _pickImage,
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                LabeledTextField(
                  controller: _nameController,
                  hintText: "e.g., Wedding Dress",
                  label: "Name",
                  labelStyle: AppStyle.body6,
                  fillColor: AppColors.lightprimery,
                  filled: true,
                ),
                SizedBox(height: 15.h),
                LabeledTextField(
                  controller: _colorController,
                  hintText: "e.g., white",
                  label: "Color",
                  labelStyle: AppStyle.body6,
                  fillColor: AppColors.lightprimery,
                  filled: true,
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdownList(
                        label: "Category",
                        value: _selectedCategory,
                        items: categories,
                        hintText: "Top",
                        onChanged: (value) =>
                            setState(() => _selectedCategory = value),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomDropdownList(
                        label: "Season",
                        value: _selectedSeason,
                        items: seasons,
                        hintText: "Summer",
                        onChanged: (value) =>
                            setState(() => _selectedSeason = value),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                BlocBuilder<ClosetCubit, ClosetState>(
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
                            backgroundColor:
                            AppColors.primery.withOpacity(0.6),
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
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter a name');
      return;
    }
    if (_colorController.text.trim().isEmpty) {
      _showSnackBar('Please enter a color');
      return;
    }
    // ✅ image required only for add
    if (!_isUpdate && _selectedImagePath == null) {
      _showSnackBar('Please select an image');
      return;
    }

    if (_isUpdate) {
      context.read<ClosetCubit>().updateClosetItem(
        itemId: widget.item!.id!,
        name: _nameController.text.trim(),
        category: _selectedCategory ?? categories.first,
        season: _selectedSeason ?? seasons.first,
        color: _colorController.text.trim(),
        imagePath: _selectedImagePath, // ✅ null if not changed
      );
    } else {
      context.read<ClosetCubit>().addClosetItem(
        name: _nameController.text.trim(),
        category: _selectedCategory ?? categories.first,
        season: _selectedSeason ?? seasons.first,
        color: _colorController.text.trim(),
        imagePath: _selectedImagePath!,
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppStyle.body6),
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