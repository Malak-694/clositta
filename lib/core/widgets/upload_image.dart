import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';

class ImageUploadWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final bool enabled;
  final double? height;
  final double? width;
  final String placeholderText;

  const ImageUploadWidget({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.onRemove,
    this.enabled = true,
    this.height,
    this.width,
    this.placeholderText = 'Tap to upload',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: imagePath == null
            ? _buildPlaceholder()
            : _buildImagePreview(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          LucideIcons.upload,
          size: 50.sp,
          color: AppColors.light,
        ),
        SizedBox(height: 10.h),
        Text(placeholderText, style: AppStyle.body5),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.file(
            File(imagePath!),
            fit: BoxFit.cover,
          ),
        ),
        if (enabled && onRemove != null) _buildRemoveButton(),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: onRemove,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: const BoxDecoration(
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
    );
  }
}