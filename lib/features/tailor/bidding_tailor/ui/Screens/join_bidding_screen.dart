import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';

class JoinBiddingScreen extends StatefulWidget {
  final String imageUrl;
  final String price;
  final String period;
  final String title;
  JoinBiddingScreen({
    super.key,
    required this.imageUrl,
    required this.price,
    required this.period,
    required this.title,
  });

  @override
  State<JoinBiddingScreen> createState() => _JoinBiddingScreenState();
}

class _JoinBiddingScreenState extends State<JoinBiddingScreen> {
  final prefs = getIt<SharedPrefHelper>();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();

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
      appBar: CustomAppBar(
        title: "Join Bidding",
        leading: true,
        leadingIcon: Icons.arrow_back,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description", style: AppStyle.headline2),
            SizedBox(height: 10.h),
            Text(widget.title, style: AppStyle.body6),
            SizedBox(height: 10.h),

            // Image upload box
            Container(
              height: 270.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage("assets/images/clothes1.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            SizedBox(height: 15.h),
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
            SizedBox(height: 15.h),
            // Description section
            Text('Description (optionoal)', style: AppStyle.body6),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'What you can offer...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12.w),
                ),
              ),
            ),
            SizedBox(height: 25.h),
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
      bottomNavigationBar: FutureBuilder<String?>(
        future: prefs.getSecureData(SharedPrefKey.role),
        builder: (context, snapshot) {
          final role = snapshot.data ?? "Customer";
          return FloatingNavBar(userRole: role, selectedIndex: 0);
        },
      ),
    );
  }

  void _submitPost() {
    // Validate and submit the post
    print(_priceController.text);
    print(_durationController.text);
    if (_priceController.text.isEmpty || _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Process submission
 

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have joined the Bidding!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back or reset form
    Navigator.pop(context);
  }
}
