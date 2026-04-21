import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/style.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../logic/rate_products_logic/rate_products_cubit.dart';
import '../../logic/rate_products_logic/rate_products_state.dart';

class RateProductWidget extends StatefulWidget {
  final String productId;
  final void Function(int rating, String comment)? onRated;

  const RateProductWidget({super.key, required this.productId, this.onRated});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate This Product',
          style: AppStyle.medBlack.copyWith(fontSize: 20.sp),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  rating = (index + 1).toDouble();
                });
              },
              child: Icon(
                Icons.star,
                size: 32,
                color: index < rating.toInt() ? Colors.amber : Colors.grey[300],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        LabeledTextField(
          hintText: 'Share your experience with us',
          hintStyle: AppStyle.medLight,
          textStyle: AppStyle.medBlack,
          controller: rateController,
        ),
        const SizedBox(height: 10),
        BlocConsumer<RateProductsCubit, RateProductsState>(
          listener: (context, state) {
            state.whenOrNull(
              success: (data) {
                // notify parent that this user has rated so UI can hide this widget
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
                      'please try again later ',
                      style: AppStyle.smallBackground,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              orElse: () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                    value: 'Submit Rating',
                    onPressed: () {
                      if (rating > 0) {
                        context.read<RateProductsCubit>().rateProduct(
                          widget.productId,
                          rating.toInt(),
                          rateController.text,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a rating'),
                          ),
                        );
                      }
                    },
                    height: 35.h,
                    width: 240.w,
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
