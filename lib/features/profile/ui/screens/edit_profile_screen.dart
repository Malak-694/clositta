import 'dart:io';
import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/circle_indicator.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
import 'package:chicora/features/profile/data/model/profile_model.dart';
import 'package:chicora/features/profile/logic/profile_cubit.dart';
import 'package:chicora/features/profile/logic/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/models/message_model.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileResponse profile;
  final Color primaryColor;
  final Color lightColor;

  const EditProfileScreen({
    super.key,
    required this.profile,
    required this.primaryColor,
    required this.lightColor,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  String? _newImagePath;
  bool _imageRemoved = false;

  @override
  void initState() {
    super.initState();
    _nameController  = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _newImagePath = picked.path;
        _imageRemoved = false;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _newImagePath = null;
      _imageRemoved = true;
    });
  }

  void _save() {
    if (_imageRemoved && widget.profile.imageUrl != null) {
      context.read<ProfileCubit>().deleteProfileImage();
    }
    context.read<ProfileCubit>().updateProfile(
      name:      _nameController.text.trim(),
      email:     _emailController.text.trim(),
      phone:     _phoneController.text.trim(),
      imagePath: _newImagePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (data) {
            if (data is MessageModel) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(data.message ?? "Profile updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            }
          },
          fail: (msg) {
            if (!_imageRemoved) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: "Edit Profile",
          leading: true,
          leadingIcon: Icons.arrow_back_ios,
          showCartIcon: false,
          onCartTap: null,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            ImageProvider? imageToShow;
            if (_newImagePath != null) {
              imageToShow = FileImage(File(_newImagePath!));
            } else if (!_imageRemoved && widget.profile.imageUrl != null) {
              imageToShow = NetworkImage(widget.profile.imageUrl!);
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                children: [

                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                                radius: 60.r,
                                backgroundColor: widget.lightColor,
                                backgroundImage: imageToShow,
                                child: imageToShow == null
                                    ? Icon(
                                  Icons.person,
                                  size: 60.sp,
                                  color: widget.primaryColor,
                                )
                                    : null,
                              )
                          ),

                        if (!_imageRemoved &&
                            (_newImagePath != null ||
                                widget.profile.imageUrl != null))
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                width: 36.w,
                                height: 36.h,
                                decoration: BoxDecoration(
                                  color: widget.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.background,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: AppColors.background,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  Text(
                    "Tap to change photo",
                    style: TextStyle(fontSize: 12.sp, color: AppColors.light),
                  ),
                  SizedBox(height: 32.h),

                  // ── Name
                  LabeledTextField(
                    controller: _nameController,
                    hintText: "Enter your name",
                    label: "Name",
                    required: true,
                    focusedBorderColor: widget.primaryColor,
                  ),
                  SizedBox(height: 16.h),

                  // ── Email
                  LabeledTextField(
                    controller: _emailController,
                    hintText: "Enter your email",
                    label: "Email",
                    required: true,
                    keyboardType: TextInputType.emailAddress,
                    focusedBorderColor: widget.primaryColor,
                  ),
                  SizedBox(height: 16.h),

                  // ── Phone
                  LabeledTextField(
                    controller: _phoneController,
                    hintText: "Enter your phone",
                    label: "Phone",
                    keyboardType: TextInputType.phone,
                    focusedBorderColor: widget.primaryColor,
                  ),
                  SizedBox(height: 220.h),

                  isLoading
                      ? Center(child: circleIndicator())
                      : CustomElevatedButton(
                    width: 380.w,
                    value: "Save Changes",
                    background: widget.primaryColor,
                    onPressed: _save,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}