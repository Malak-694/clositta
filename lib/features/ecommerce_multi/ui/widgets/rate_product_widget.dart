import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../logic/rate_products_logic/rate_products_cubit.dart';
import '../../logic/rate_products_logic/rate_products_state.dart';

class RateProductWidget extends StatefulWidget {
  final String productId;
  final void Function(int rating, String comment)? onRated;
  final Color accent;
  final Color accentDark;

  const RateProductWidget({
    super.key,
    required this.productId,
    this.onRated,
    this.accent = AppColors.primery,
    this.accentDark = AppColors.darkprimery,
  });

  @override
  State<RateProductWidget> createState() => _RateProductWidgetState();
}

class _RateProductWidgetState extends State<RateProductWidget> {
  final TextEditingController rateController = TextEditingController();
  double rating = 0;

  @override
  void dispose() {
    rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: widget.accent.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write a review',
            style: AppStyle.body6.copyWith(
              color: widget.accentDark,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      rating = (index + 1).toDouble();
                    });
                  },
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(
                      index < rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 36.sp,
                      color: index < rating
                          ? AppColors.secondary
                          : AppColors.light.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          LabeledTextField(
            hintText: 'Share your experience',
            hintStyle: AppStyle.medLight,
            textStyle: AppStyle.medBlack,
            controller: rateController,
          ),
          SizedBox(height: 16.h),
          BlocConsumer<RateProductsCubit, RateProductsState>(
            listener: (context, state) {
              state.whenOrNull(
                success: (data) {
                  widget.onRated?.call(rating.toInt(), rateController.text);
                  rateController.clear();
                  setState(() {
                    rating = 0;
                  });
                },
                fail: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please try again later',
                        style: AppStyle.medBackground,
                      ),
                      backgroundColor: AppColors.ternary,
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => Center(
                  child: SizedBox(
                    width: 28.w,
                    height: 28.h,
                    child: CircularProgressIndicator(
                      color: widget.accent,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
                orElse: () => Center(
                  child: CustomElevatedButton(
                    value: 'Submit review',
                    background: widget.accentDark,
                    onPressed: () {
                      if (rating > 0) {
                        context.read<RateProductsCubit>().rateProduct(
                          widget.productId,
                          rating.toInt(),
                          rateController.text,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Select a star rating first',
                              style: AppStyle.medBackground,
                            ),
                            backgroundColor: AppColors.darksecondary,
                          ),
                        );
                      }
                    },
                    height: 46.h,
                    width: 1.sw - 64.w,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
