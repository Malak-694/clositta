import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/join_bidding_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_state.dart';
import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';

class JoinBiddingScreen extends StatefulWidget {
  final String imageUrl;
  final String price;
  final String period;
  final String title;
  final String postId;
  final prefs = getIt<SharedPrefHelper>();

  JoinBiddingScreen({
    super.key,
    required this.imageUrl,
    required this.price,
    required this.period,
    required this.title,
    required this.postId,
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
    return BlocConsumer<BiddingTailorCubit, BiddingTailorState>(
      listener: (context, state) {
        if (state is Success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'your bidding has been created successfully!',
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
                'Something wrong happens, please try again later.',
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
          appBar: CustomAppBar(
            title: "Join Bidding",
            leading: true,
            leadingIcon: Icons.arrow_back,
            showCartIcon: true,
            onCartTap: () =>
                Navigator.pushNamed(context, RouteNames.tailor_cart_screen),
          ),
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description", style: AppStyle.boldSecondary),
                SizedBox(height: 10.h),
                Text(widget.title, style: AppStyle.body6),
                SizedBox(height: 10.h),

                // Image upload box
                Container(
                  height: 270.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
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
                    enabled: !isLoading,

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
                    onPressed: () => _submitPost(context),
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
              final role = snapshot.data ?? "tailor";
              return FloatingNavBar(userRole: role, selectedIndex: 0);
            },
          ),
        );
      },
    );
  }

  void _submitPost(BuildContext context) {
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
    final cubit = context.read<BiddingTailorCubit>();

    final request = JoinBiddingRequest(
      price: int.tryParse(_priceController.text),
      timeInDays: int.tryParse(_durationController.text),
      message: _descriptionController.text,
    );

    cubit.joinBidding(postId: widget.postId, request: request).then((_) {
      // The cubit will emit states; listen via BlocListener in parent if needed
    });
  }
}
