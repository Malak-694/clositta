import 'package:chicora/features/ecommerce_multi/ui/widgets/cart_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/models/message_model.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../data/models/cart_models/cart_response_model.dart';
import '../../data/models/cart_models/delete_cart_response_model.dart';
import '../../logic/cart_cubit/cart_cubit.dart';
import '../../logic/cart_cubit/cart_state.dart';
import '../../logic/order_cubit/order_cubit.dart';
import '../screens/checkout_screen.dart';
import '../screens/order_view_screen.dart';
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
  List<CartSubOrder> _cachedSubOrders = [];
  Color _rolePrimary = AppColors.primery;
  Color _roleDark = AppColors.darkprimery;

  @override
  void initState() {
    super.initState();
    AppColors.primaryForCurrentUser().then((color) {
      if (!mounted) return;
      setState(() => _rolePrimary = color);
    });
    AppColors.darkForCurrentUser().then((color) {
      if (!mounted) return;
      setState(() => _roleDark = color);
    });
    context.read<CartCubit>().getCart();
  }

  double _calculateSubtotal(List<Item>? items) {
    if (items == null) return 0;
    return items.fold(
      0,
      (sum, item) =>
          sum +
          (item.subtotal ?? (item.priceAtAddTime ?? 0) * (item.quantity ?? 1)),
    );
  }

  List<MapEntry<String, List<Item>>> _groupItemsBySeller(List<Item> items) {
    final grouped = <String, List<Item>>{};
    for (final item in items) {
      final sellerId = item.product?.seller;
      final key = (sellerId != null && sellerId.isNotEmpty)
          ? sellerId
          : 'unknown_seller';
      grouped.putIfAbsent(key, () => <Item>[]).add(item);
    }
    return grouped.entries.toList();
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
                _cachedSubOrders = data.subOrders ?? [];
                _cachedCartItems = data.items ?? [];
                _updatingItems.clear();
              });
            } else if (data is DeleteCartResponseModel) {
              setState(() {
                _cachedSubOrders = data.cart?.subOrders ?? [];
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
        final bool isMainLoading =
            state is Loading &&
            _cachedCartItems.isEmpty &&
            _cachedSubOrders.isEmpty;
        final List<Item> displayItems = _cachedSubOrders.isNotEmpty
            ? _cachedSubOrders
                  .expand((subOrder) => subOrder.items ?? const <Item>[])
                  .toList()
            : _cachedCartItems;
        final double subtotal = _calculateSubtotal(displayItems);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isMainLoading
              ? Center(child: CircularProgressIndicator(color: _rolePrimary))
              : Column(
                  children: [
                    Expanded(
                      child: displayItems.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Your cart is empty',
                                    style: AppStyle.medBlack.copyWith(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  CustomElevatedButton(
                                    value: 'View my orders',
                                    height: 46.h,
                                    width: 190.w,
                                    background: _rolePrimary,
                                    style: AppStyle.smallBackground.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const OrderViewScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 16,
                              ),
                              children: [
                                ..._groupItemsBySeller(displayItems).map((
                                  sellerGroup,
                                ) {
                                  final sellerId = sellerGroup.key;
                                  final sellerItems = sellerGroup.value;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 4.w,
                                          right: 4.w,
                                          top: 8.h,
                                          bottom: 6.h,
                                        ),
                                        child: Text(
                                          sellerId == 'unknown_seller'
                                              ? 'Seller'
                                              : 'Seller: $sellerId',
                                          style: AppStyle.medBlack.copyWith(
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      ...sellerItems.map((item) {
                                        return ProductCartCard(
                                          item: item,
                                          isUpdating: _updatingItems.contains(
                                            item.product?.pId,
                                          ),
                                          onIncrement: () {
                                            final pId = item.product?.pId;
                                            if (pId != null) {
                                              context
                                                  .read<CartCubit>()
                                                  .updateCart(
                                                    pId,
                                                    (item.quantity ?? 1) + 1,
                                                  );
                                            }
                                          },
                                          onDecrement: () {
                                            final pId = item.product?.pId;
                                            if (pId != null &&
                                                (item.quantity ?? 1) > 1) {
                                              context
                                                  .read<CartCubit>()
                                                  .updateCart(
                                                    pId,
                                                    (item.quantity ?? 1) - 1,
                                                  );
                                            }
                                          },
                                          onRemove: () {
                                            final pId = item.product?.pId;
                                            if (pId != null) {
                                              context
                                                  .read<CartCubit>()
                                                  .removeFromCart(pId);
                                            }
                                          },
                                        );
                                      }),
                                      SizedBox(height: 4.h),
                                    ],
                                  );
                                }),
                                OrderSummary(
                                  subtotal: subtotal,
                                  shippingValueText: 'Calculated at checkout',
                                  backgroundColor: _rolePrimary.withOpacity(
                                    0.12,
                                  ),
                                  accentColor: _roleDark,
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 10.h),
                    if (displayItems.isNotEmpty) ...[
                      CustomElevatedButton(
                        value: 'Proceed to Checkout',
                        height: 50.h,
                        style: AppStyle.medBackground.copyWith(fontSize: 18.sp),
                        background: _rolePrimary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<CartCubit>(),
                                  ),
                                  BlocProvider(
                                    create: (_) => getIt<OrderCubit>(),
                                  ),
                                ],
                                child: const CheckoutScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomElevatedButton(
                              value: 'View my orders',
                              height: 46.h,
                              width: 190.w,
                              style: AppStyle.smallBackground.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              background: _rolePrimary,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const OrderViewScreen(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 10.w),
                            CustomElevatedButton(
                              value: 'Remove cart',
                              height: 46.h,
                              width: 130.w,
                              style: AppStyle.boldBackground.copyWith(
                                fontSize: 12.sp,
                              ),
                              onPressed: () =>
                                  context.read<CartCubit>().removeAllCart(),
                              background: AppColors.ternary,
                            ),
                          ],
                        ),
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
