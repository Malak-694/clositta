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
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';

class JoinBiddingScreen extends StatefulWidget {
  final String imageUrl;
  final String price;
  final String period;
  final String title;
  final String postId;

  final String? offerId;
  final String? initialPrice;
  final String? initialDays;
  final String? initialMessage;

  bool get isEditMode => offerId != null;

  const JoinBiddingScreen({
    super.key,
    required this.imageUrl,
    required this.price,
    required this.period,
    required this.title,
    required this.postId,
    this.offerId,
    this.initialPrice,
    this.initialDays,
    this.initialMessage,
  });

  @override
  State<JoinBiddingScreen> createState() => _JoinBiddingScreenState();
}

class _JoinBiddingScreenState extends State<JoinBiddingScreen> {
  final prefs = getIt<SharedPrefHelper>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.initialPrice ?? '');
    _durationController = TextEditingController(text: widget.initialDays ?? '');
    _descriptionController = TextEditingController(text: widget.initialMessage ?? '');

  }

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
                widget.isEditMode
                    ? 'Offer updated successfully!'
                    : 'Your bidding has been created successfully!',
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
                'Something went wrong, please try again later.',
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
            title: widget.isEditMode ? "Edit Offer" : "Join Bidding",
            leading: true,
            leadingIcon: Icons.arrow_back,
            showCartIcon: false,
            onCartTap: () {},
            extraActions: widget.isEditMode
                ? [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: IconButton(
                  icon: Icon(Icons.delete_outline, color: AppColors.ternary ,size: 30,),
                  onPressed: isLoading ? null : () => _confirmDeleteOffer(context,widget.offerId!),
                  tooltip: 'Delete Post',
                ),
              ),
            ]
                : [],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description", style: AppStyle.boldSecondary),
                SizedBox(height: 10.h),
                Text(widget.title, style: AppStyle.body6),
                SizedBox(height: 10.h),

                // ── Image ────────────────────────────────────────
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

                // ── Price + Duration ─────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price', style: AppStyle.body6),
                          SizedBox(height: 8.h),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: TextField(
                              enabled: !isLoading,
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              style: AppStyle.body6,
                              decoration: InputDecoration(
                                hintText: 'write the price',
                                hintStyle: AppStyle.smallBlack.copyWith(
                                  color: AppColors.light,
                                ),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration (days)', style: AppStyle.body6),
                          SizedBox(height: 8.h),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: TextField(
                              enabled: !isLoading,
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              style: AppStyle.body6,
                              decoration: InputDecoration(
                                hintText: 'write the duration',
                                hintStyle: AppStyle.smallBlack.copyWith(
                                  color: AppColors.light,
                                ),
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

                // ── Message ──────────────────────────────────────
                Text(
                  'Description (optional)',
                  style: AppStyle.body6,
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    enabled: !isLoading,
                    controller: _descriptionController,
                    maxLines: 3,
                    style: AppStyle.body6,
                    decoration: InputDecoration(
                      hintText: 'What you can offer...',
                      hintStyle: AppStyle.smallBlack.copyWith(
                        color: AppColors.light,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.w),
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                // ── Submit button ────────────────────────────────
                if (isLoading)
                  SizedBox(
                    width: double.infinity,
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
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () => _submitPost(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primery,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        widget.isEditMode ? 'Save Changes' : 'Post for Bids',
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
    if (_priceController.text.isEmpty || _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cubit = context.read<BiddingTailorCubit>();

    if (widget.isEditMode) {
      // ── EDIT ──
      cubit.updateOffer(
        offerId: widget.offerId!,
        postId: widget.postId,
        price: _priceController.text,
        timeInDays: _durationController.text,
        message: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
      );
    } else {
      // ── JOIN ──
      final request = JoinBiddingRequest(
        price: int.tryParse(_priceController.text),
        timeInDays: int.tryParse(_durationController.text),
        message: _descriptionController.text,
      );
      cubit.joinBidding(postId: widget.postId, request: request);
    }
  }
  void _confirmDeleteOffer(BuildContext context, String offerId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text('Delete Offer', style: AppStyle.body6),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this offer? This action cannot be undone.',
          style: AppStyle.body6.copyWith(fontWeight: FontWeight.normal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: AppStyle.medSecondary),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BiddingTailorCubit>().deleteOffer(
                offerId: offerId,
                postId: widget.postId,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}