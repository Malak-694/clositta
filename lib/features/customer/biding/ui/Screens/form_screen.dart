import 'dart:io';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: AppStyle.body6.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = AppColors.ternary,
                ),
              ),
              backgroundColor: AppColors.lightsecondary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is Loading;

        return Scaffold(
          appBar: AppBar(
            title: Text('cancel', style: AppStyle.boldTernary),
            leadingWidth: 20.w,
            iconTheme: IconThemeData(color: AppColors.ternary),
            backgroundColor: AppColors.background,
          ),
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("create new post", style: AppStyle.boldSecondary),
                SizedBox(height: 10.h),
                Text('upload design photo', style: AppStyle.body6),
                SizedBox(height: 10.h),

                // Image upload box
                GestureDetector(
                  onTap: isLoading ? null : _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _selectedImagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.upload,
                                size: 50.sp,
                                color: AppColors.light,
                              ),
                              SizedBox(height: 10.h),
                              Text('Tap to upload', style: AppStyle.body5),
                            ],
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  File(_selectedImagePath!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (!isLoading)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImagePath = null;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Description section
                Text('Description', style: AppStyle.body6),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    enabled: !isLoading,
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Enter detailed description...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.w),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Price and Duration row
                Row(
                  children: [
                    // Price section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price', style: AppStyle.body6),
                          SizedBox(height: 8.h),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: TextField(
                              enabled: !isLoading,
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'write the price',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12.w),
                                prefixIcon: Icon(
                                  LucideIcons.dollarSign,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),

                    // Duration section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration (days)', style: AppStyle.body6),
                          SizedBox(height: 8.h),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: TextField(
                              enabled: !isLoading,
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'write the duration',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12.w),
                                suffixIcon: Icon(
                                  LucideIcons.calendarDays,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

                // Post for Bids button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _submitPost(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primery,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                      disabledBackgroundColor: AppColors.primery.withOpacity(
                        0.6,
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Post for Bids',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
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

  void _submitPost(BuildContext context) {
    // Validate
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a description', style: AppStyle.body6),
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

    // Get cubit and submit
    final cubit = context.read<CustomerBiddingCubit>();

    // Create request model
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

    // Call cubit method
    cubit.createBid(request: request);
  }
}
