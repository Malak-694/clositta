import 'package:chicora/features/ecommerce_multi/data/models/cart_models/cart_response_model.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/quantity_counter_widget.dart';

class AddToCartSection extends StatefulWidget {
  final String productId;
  /// Role-based primary accent (buttons, loading).
  final Color accent;
  final Color accentDark;

  const AddToCartSection({
    required this.productId,
    super.key,
    this.accent = AppColors.primery,
    this.accentDark = AppColors.darkprimery,
  });

  @override
  State<AddToCartSection> createState() => AddToCartSectionState();
}

class AddToCartSectionState extends State<AddToCartSection> {
  int _quantity = 1;
  bool _addedToCart = false;

  // ✅ Moved out of build — only runs once on init, not on every rebuild
  @override
  void initState() {
    super.initState();
    _syncWithCartState(context.read<CartCubit>().state);
  }

  // ✅ Single method to sync local state from any CartState
  void _syncWithCartState(CartState state) {
    if (state is Success) {
      final data = state.data;
      if (data is CartResponseModel) {
        final match = data.items?.firstWhere(
          (item) => item.product?.pId == widget.productId,
          orElse: () => Item(), // returns empty Item if not found
        );

        final isInCart = match?.product?.pId != null;

        // avoid calling setState before build if called from initState
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _addedToCart = isInCart;
            // ✅ if already in cart, show its current cart quantity
            if (isInCart) _quantity = match?.quantity ?? 1;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (prev, curr) => curr is Success || curr is Fail,
      buildWhen: (prev, curr) =>
          curr is Success || curr is Fail || curr is Loading,
      listener: (context, state) {
        state.whenOrNull(
          success: (data) => _syncWithCartState(state),
          fail: (msg) {
            setState(() => _addedToCart = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg, style: AppStyle.medBlack)),
            );
          },
        );
      },
      builder: (context, state) {
        final isLoading = state is Loading;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuantityCounter(
                  quantity: _quantity,
                  accent: widget.accent,
                  onIncrement: () => setState(() => _quantity++),
                  onDecrement: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),
              ],
            ),
            SizedBox(height: 16.h),
            isLoading
                ? Center(
                    child: SizedBox(
                      width: 28.w,
                      height: 28.h,
                      child: CircularProgressIndicator(
                        color: widget.accent,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                : _addedToCart
                ? CustomElevatedButton(
                    value: 'Added to cart',
                    style: AppStyle.medBlack.copyWith(fontSize: 18.sp),
                    height: 48.h,
                    width: 1.sw - 64.w,
                    background: AppColors.lightprimery,
                    onPressed: () {
                      setState(() {
                        _addedToCart = false;
                        _quantity = 1;
                      });
                    },
                  )
                : CustomElevatedButton(
                    value: 'Add to cart',
                    height: 48.h,
                    width: 1.sw - 64.w,
                    background: widget.accentDark,
                    onPressed: () {
                      context.read<CartCubit>().addToCart(
                        widget.productId,
                        _quantity,
                      );
                    },
                  ),
          ],
        );
      },
    );
  }
}
