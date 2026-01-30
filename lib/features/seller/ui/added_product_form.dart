import 'dart:io';

import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
import 'package:chicora/core/widgets/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/colors.dart';

class AddedProductForm extends StatefulWidget {
  const AddedProductForm({super.key});

  @override
  State<AddedProductForm> createState() => _AddedProductFormState();
}

class _AddedProductFormState extends State<AddedProductForm> {
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<String> categories = [
    "Top",
    "Bottom",
    "Dress",
    "Outerwear",
    "Footwear",
    "Accessories",
  ];
  String? _selectedCategory = "Top";
  String? _selectedImagePath;

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "added new item"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("upload Image", style: AppStyle.body6),
                  SizedBox(height: 10.h),
                  ImageUploadWidget(
                    height: 150.h,
                    imagePath: _selectedImagePath,
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
                hintText: "Describe your product... ",
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
                  SizedBox(width: 10.w), // Add spacing between dropdowns
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
              CustomDropdownList(
                label: "Category",
                value: _selectedCategory,
                items: categories,
                hintText: "select category",
                onChanged: (value) => setState(() => _selectedCategory = value,)
              ),
              SizedBox(height: 30.h),
              CustomElevatedButton(
                value: "add product",
                onPressed: _submitPost,
                height: 48,
                width: 380,
                background: AppColors.primery,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPost() {
    // Validate
    if (_productNameController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty
      ||_priceController.text.trim().isEmpty || _stockController.text.trim().isEmpty
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter all field', style: AppStyle.body6),
          backgroundColor: AppColors.lightsecondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image', style: AppStyle.body6),
          backgroundColor: AppColors.lightsecondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
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

        // Check if file is less than 5MB
        if (fileSize > 5 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Image size must be less than 5MB',
                  style: AppStyle.body6,
                ),
                backgroundColor: AppColors.lightsecondary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        setState(() {
          _selectedImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e', style: AppStyle.body6),
            backgroundColor: AppColors.lightsecondary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
