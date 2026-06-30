import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> showRateTailorSheet({
  required BuildContext context,
  required String offerId,
  required String tailorName,
  required Future<void> Function(int rating, String? comment) onSubmit,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.5),
    backgroundColor: Colors.transparent,
    builder: (_) => RateTailorBottomSheet(
      offerId: offerId,
      tailorName: tailorName,
      onSubmit: onSubmit,
    ),
  );
}

class RateTailorBottomSheet extends StatefulWidget {
  final String offerId;
  final String tailorName;
  final Future<void> Function(int rating, String? comment) onSubmit;

  const RateTailorBottomSheet({
    super.key,
    required this.offerId,
    required this.tailorName,
    required this.onSubmit,
  });

  @override
  State<RateTailorBottomSheet> createState() => _RateTailorBottomSheetState();
}

class _RateTailorBottomSheetState extends State<RateTailorBottomSheet> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedRating == 0) {
      setState(() => _error = 'Please select a rating.');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await widget.onSubmit(
        _selectedRating,
        _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = 'Failed to submit rating. Try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),

            Text(
              'Rate ${widget.tailorName}',
              style: AppStyle.medBlack,
            ),
            SizedBox(height: 6.h),
            Text(
              'How was your experience?',
              style: AppStyle.medLight,
            ),
            SizedBox(height: 20.h),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final star = i + 1;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedRating = star;
                    _error = null;
                  }),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Icon(
                      star <= _selectedRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 40.sp,
                      color: star <= _selectedRating
                          ? const Color(0xFFFFB800)
                          : AppColors.light,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20.h),

            // Comment
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Leave a comment (optional)',
                hintStyle: AppStyle.medLight,
                filled: true,
                fillColor: AppColors.lightprimery.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),

            if (_error != null) ...[
              SizedBox(height: 8.h),
              Text(
                _error!,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ],

            SizedBox(height: 20.h),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primery,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child:  CircularProgressIndicator(
                    color: Theme.of(context).cardColor,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                    'Submit Rating',
                    style: AppStyle.medBackground
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}