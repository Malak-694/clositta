
import  'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  String? _selectedImage;

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cancel', style: AppStyle.headline4),
        leadingWidth: 20.w,
        iconTheme: IconThemeData(
          color: AppColors.ternary, // Change arrow color
        ),
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("create new post" , style: AppStyle.headline2,),
            SizedBox(height: 10.h,),
            Text(
              'upload design photo',
              style: AppStyle.body6
            ),
            SizedBox(height: 10.h),

            // Image upload box
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                 // color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _selectedImage == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.upload,
                      size: 50.sp,
                      color: AppColors.light,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Tap to upload',
                      style: AppStyle.body5
                    ),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Description section
            Text(
              'Description',
              style: AppStyle.body6
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
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
                      Text(
                        'Price',
                        style: AppStyle.body6
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'write the price',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12.w),
                            prefixIcon: Icon(LucideIcons.dollarSign, size: 20.sp),
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
                      Text(
                        'Duration (days)',
                        style: AppStyle.body6
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextField(
                          controller: _durationController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'write the duration',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12.w),
                            suffixIcon: Icon(LucideIcons.calendarDays, size: 20.sp),
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
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primery, // Use your color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                ),
                child: Text(
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
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Handle the picked image
      setState(() {
        // Store the image path
        _selectedImage = pickedFile.path;
      });
    }
  }

  void _submitPost() {
    // Validate and submit the post
    if (_descriptionController.text.isEmpty || _selectedImage==null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Process submission
    print('Post submitted!');
    print('Description: ${_descriptionController.text}');
    print('Price: ${_priceController.text}');
    print('Duration: ${_durationController.text}');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post created successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back or reset form
    Navigator.pop(context);
  }
}