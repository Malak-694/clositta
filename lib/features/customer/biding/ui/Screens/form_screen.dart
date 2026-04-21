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
  final String? bidId;
  final String? initialDescription;
  final String? initialImageUrl;
  final double? initialPrice;
  final String? initialDuration;

  const FormScreen({
    super.key,
    this.bidId,
    this.initialDescription,
    this.initialImageUrl,
    this.initialPrice,
    this.initialDuration,
  });

  bool get isEditMode => bidId != null;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;

  String? _selectedImagePath;
  String? _existingImageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
    _priceController = TextEditingController(text: widget.initialPrice?.toString() ?? '');
    _durationController = TextEditingController(text: widget.initialDuration ?? '');
    _existingImageUrl = widget.initialImageUrl;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // ── Delete confirmation dialog ───────────────────────────
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text('Delete Post', style: AppStyle.body6),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
          style: AppStyle.body6.copyWith(fontWeight: FontWeight.normal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: AppStyle.medPrimery),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CustomerBiddingCubit>().deleteBid(
                bidId: widget.bidId!,
              );
            },
            child: Text('Delete', style: AppStyle.medTernary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBiddingCubit, CustomerBiddingState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          fail: (msg) => _showSnackBar(msg),
          success: (data) {
            final message = data is String
                ? data
                : widget.isEditMode
                ? 'Post updated successfully!'
                : 'Bid created successfully!';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message, style: AppStyle.body6),
                backgroundColor: AppColors.lightprimery,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: widget.isEditMode ? 'Edit Post' : 'Create New Post',
            leading: true,
            showCartIcon: false,
            onCartTap: () {},
            // ✅ Delete icon in appbar — only in edit mode
            extraActions: widget.isEditMode
                ? [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: IconButton(
                  icon: Icon(Icons.delete_outline, color: AppColors.ternary ,size: 30,),
                  onPressed: isLoading ? null : () => _confirmDelete(context),
                  tooltip: 'Delete Post',
                ),
              ),
            ]
                : [],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image ────────────────────────────────────────
                Text('Upload Design Photo', style: AppStyle.body6),
                SizedBox(height: 10.h),

                if (_selectedImagePath == null && _existingImageUrl != null)
                  GestureDetector(
                    onTap: isLoading ? null : _pickImage,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _existingImageUrl!,
                            height: 180.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 180.h,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        ),
                        // ✅ Dark overlay with camera icon to hint it's tappable
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.black.withOpacity(0.25),
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ImageUploadWidget(
                    imagePath: _selectedImagePath,
                    onTap: isLoading ? () {} : _pickImage,
                    onRemove: isLoading
                        ? null
                        : () => setState(() {
                      _selectedImagePath = null;
                      _existingImageUrl = widget.initialImageUrl;
                    }),
                    enabled: !isLoading,
                  ),

                SizedBox(height: 20.h),

                // ── Description ──────────────────────────────────
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

                // ── Price + Duration ─────────────────────────────
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

                // ── Submit button ────────────────────────────────
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
                    value: widget.isEditMode ? 'Save Changes' : 'Post for Bids',
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

    if (!widget.isEditMode && _selectedImagePath == null) {
      _showSnackBar('Please select an image');
      return;
    }

    if (widget.isEditMode) {
      context.read<CustomerBiddingCubit>().updateBid(
        bidId: widget.bidId!,
        description: _descriptionController.text.trim(),
        imagePath: _selectedImagePath,
        price: _priceController.text.isNotEmpty
            ? double.tryParse(_priceController.text)
            : null,
        time: _durationController.text.isNotEmpty
            ? _durationController.text
            : null,
      );
    } else {
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