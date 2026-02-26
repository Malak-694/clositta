import 'dart:io';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
import 'package:chicora/core/widgets/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_state.dart';
import 'package:chicora/features/customer/biding/data/models/send_bidding_model.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBiddingCubit, CustomerBiddingState>(
      listener: (context, state) {
        if (state is Success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Your bid has been created successfully!',
                style: AppStyle.body6,
              ),
              backgroundColor: AppColors.lightprimery,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else if (state is Fail) {
          _showSnackBar(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is Loading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: 'Create New Post' , leading: true,),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image upload
                Text('Upload Design Photo', style: AppStyle.body6),
                SizedBox(height: 10.h),
                ImageUploadWidget(
                  imagePath: _selectedImagePath,
                  onTap: isLoading ? () {} : _pickImage,
                  onRemove: isLoading
                      ? null
                      : () => setState(() => _selectedImagePath = null),
                  enabled: !isLoading,
                ),
                SizedBox(height: 20.h),

                // description
                LabeledTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hintText: 'Enter detailed description...',
                  maxLines: 5,
                  labelStyle: AppStyle.body6,
                  fillColor: AppColors.lightprimery,
                  filled: true,
                  enabled: !isLoading,
                ),
                SizedBox(height: 20.h),

                // price and duration
                Row(
                  children: [
                    Expanded(
                      child: LabeledTextField(
                        controller: _priceController,
                        label: 'Price',
                        hintText: 'Write the price',
                        keyboardType: TextInputType.number,
                        labelStyle: AppStyle.body6,
                        fillColor: AppColors.lightprimery,
                        filled: true,
                        enabled: !isLoading,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: LabeledTextField(
                        controller: _durationController,
                        label: 'Duration (days)',
                        hintText: 'Write the duration',
                        keyboardType: TextInputType.number,
                        labelStyle: AppStyle.body6,
                        fillColor: AppColors.lightprimery,
                        filled: true,
                        enabled: !isLoading,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

                // submit button
                if (isLoading)
                  SizedBox(
                    width: 380.w,
                    height: 56.h,
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
                  )
                else
                  CustomElevatedButton(
                    value: 'Post for Bids',
                    onPressed: () => _submitPost(context),
                    height: 56,
                    width: 380.w,
                  ),
              ],
            ),
          ),
        );
      },
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

  void _submitPost(BuildContext context) {
    if (_descriptionController.text.trim().isEmpty) {
      _showSnackBar('Please enter a description');
      return;
    }

    if (_selectedImagePath == null) {
      _showSnackBar('Please select an image');
      return;
    }

    final request = SendBiddingModel(
      description: _descriptionController.text.trim(),
      imageUrl: _selectedImagePath!,
      price: _priceController.text.isNotEmpty
          ? double.tryParse(_priceController.text)
          : null,
      time: _durationController.text.isNotEmpty
          ? _durationController.text
          : null,
    );

    context.read<CustomerBiddingCubit>().createBid(request: request);
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
}