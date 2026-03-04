import 'package:chicora/features/ecommerce_multi/ui/widgets/cart_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/models/message_model.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../data/models/cart_models/cart_response_model.dart';
import '../../data/models/cart_models/delete_cart_response_model.dart';
import '../../logic/cart_cubit/cart_cubit.dart';
import '../../logic/cart_cubit/cart_state.dart';
import '../widgets/order_summary_widget.dart';

class CartScreenBody extends StatefulWidget {
  const CartScreenBody({super.key});

  @override
  State<CartScreenBody> createState() => _CartScreenBodyState();
}

class _CartScreenBodyState extends State<CartScreenBody> {
  // Keeps track of item IDs that are currently updating quantity/removing
  final Set<String> _updatingItems = {};
  List<Item> _cachedCartItems = [];
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  double _calculateSubtotal(List<Item>? items) {
    if (items == null) return 0;
    return items.fold(
      0,
      (sum, item) => sum + (item.priceAtAddTime ?? 0) * (item.quantity ?? 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        state.whenOrNull(
          // Cache items on success so they survive Loading state
          success: (data) {
            if (data is CartResponseModel) {
              setState(() {
                _cachedCartItems = data.items ?? [];
                _updatingItems.clear();
              });
            } else if (data is DeleteCartResponseModel) {
              setState(() {
                _cachedCartItems = data.cart?.items ?? [];
                _updatingItems.clear();
              });
              context.read<CartCubit>().getCart();
            } else if (data is MessageModel) {
              _updatingItems.clear();
              context.read<CartCubit>().getCart();
            }
          },
          updateQuantityLoading: (productId) {
            setState(() => _updatingItems.add(productId));
          },
          fail: (message) {
            setState(() => _updatingItems.clear());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message, style: AppStyle.medBlack)),
            );
          },
        );
      },
      builder: (context, state) {
        final bool isMainLoading = state is Loading && _cachedCartItems.isEmpty;
        final double subtotal = _calculateSubtotal(_cachedCartItems);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isMainLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: _cachedCartItems.isEmpty
                          ? const Center(
                              child: Text(
                                'Your cart is empty',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 16,
                              ),
                              itemCount: _cachedCartItems.length + 1,
                              itemBuilder: (context, i) {
                                if (i == _cachedCartItems.length) {
                                  return OrderSummary(subtotal: subtotal);
                                }
                                final item = _cachedCartItems[i];
                                return ProductCartCard(
                                  item: item,
                                  isUpdating: _updatingItems.contains(
                                    item.product?.pId,
                                  ),
                                  onIncrement: () {
                                    final pId = item.product?.pId;
                                    if (pId != null) {
                                      context.read<CartCubit>().updateCart(
                                        pId,
                                        (item.quantity ?? 1) + 1,
                                      );
                                    }
                                  },
                                  onDecrement: () {
                                    final pId = item.product?.pId;
                                    if (pId != null &&
                                        (item.quantity ?? 1) > 1) {
                                      context.read<CartCubit>().updateCart(
                                        pId,
                                        (item.quantity ?? 1) - 1,
                                      );
                                    }
                                  },
                                  onRemove: () {
                                    final pId = item.product?.pId;
                                    if (pId != null) {
                                      // We can use the same update loading UI for remove
                                      context.read<CartCubit>().removeFromCart(
                                        pId,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 10.h),
                    if (_cachedCartItems.isNotEmpty) ...[
                      CustomElevatedButton(
                        value: 'Proceed to Checkout',
                        height: 50.h,
                        style: AppStyle.medBackground.copyWith(fontSize: 18.sp),
                        onPressed: () {},
                      ),
                      SizedBox(height: 16.h),

                      CustomElevatedButton(
                        value: 'Remove All items from cart',
                        height: 50.h,
                        style: AppStyle.boldBackground.copyWith(
                          fontSize: 18.sp,
                        ),
                        onPressed: () =>
                            context.read<CartCubit>().removeAllCart(),
                        background: AppColors.ternary,
                      ),
                    ],
                    SizedBox(height: 30.h),
                  ],
                ),
        );
      },
    );
  }
}
