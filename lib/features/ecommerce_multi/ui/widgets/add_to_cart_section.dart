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
  const AddToCartSection({required this.productId, super.key});

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
            // ✅ Always show counter, quantity reflects cart or local selection
            QuantityCounter(
              quantity: _quantity,
              onIncrement: () => setState(() => _quantity++),
              onDecrement: () {
                if (_quantity > 1) setState(() => _quantity--);
              },
            ),
            SizedBox(height: 8.h),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : _addedToCart
                ? CustomElevatedButton(
                    value: '✓ Added to Cart',
                    style: AppStyle.medBlack,
                    height: 40.h,
                    width: 200.w,
                    background: AppColors.lightprimery,
                    onPressed: () {
                      // ✅ tapping again resets so user can re-add
                      setState(() {
                        _addedToCart = false;
                        _quantity = 1;
                      });
                    },
                  )
                : CustomElevatedButton(
                    value: 'Add to Cart',
                    height: 40.h,
                    width: 200.w,
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
