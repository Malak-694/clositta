import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_response_model.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_state.dart';
import 'package:chicora/features/ecommerce_multi/ui/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderViewScreen extends StatelessWidget {
  const OrderViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderCubit>()..getMyOrders(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(
          title: 'My Orders',
          leading: true,
          showCartIcon: false,
          onCartTap: null,
        ),
        body: const OrderViewBody(),
      ),
    );
  }
}

class OrderViewBody extends StatelessWidget {
  const OrderViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            if (data is MessageModel) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    data.message ?? 'Order updated successfully',
                    style: AppStyle.smallBackground,
                  ),
                  backgroundColor: AppColors.primery,
                ),
              );
              context.read<OrderCubit>().getMyOrders();
            }
          },
          fail: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message, style: AppStyle.smallBackground),
                backgroundColor: AppColors.ternary,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (data) {
            if (data is! List<OrderDataModel>) {
              return _EmptyOrders(
                onRefresh: () => context.read<OrderCubit>().getMyOrders(),
              );
            }
            if (data.isEmpty) {
              return _EmptyOrders(
                onRefresh: () => context.read<OrderCubit>().getMyOrders(),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<OrderCubit>().getMyOrders(),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final order = data[index];
                  return OrderCardWidget(
                    order: order,
                    onTap: () => _showOrderDetails(context, order),
                  );
                },
              ),
            );
          },
          fail: (_) => _EmptyOrders(
            onRefresh: () => context.read<OrderCubit>().getMyOrders(),
          ),
        );
      },
    );
  }

  void _showOrderDetails(BuildContext context, OrderDataModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Order Details',
                  style: AppStyle.medBlack.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 10.h),
                _DetailLine(label: 'Order ID', value: order.id ?? '-'),
                _DetailLine(label: 'Status', value: order.orderStatus ?? '-'),
                _DetailLine(
                  label: 'Payment',
                  value: order.paymentStatus ?? '-',
                ),
                _DetailLine(
                  label: 'Total',
                  value: '${order.totalAmount ?? 0} EGP',
                ),
                SizedBox(height: 8.h),
                if (_canCancel(order.orderStatus))
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _showCancelOrderDialog(context, order),
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: AppColors.ternary,
                      ),
                      label: Text(
                        'Cancel Order',
                        style: AppStyle.body6.copyWith(color: AppColors.ternary),
                      ),
                    ),
                  ),
                SizedBox(height: 10.h),
                Text(
                  'Items',
                  style: AppStyle.medPrimery.copyWith(fontSize: 16.sp),
                ),
                SizedBox(height: 8.h),
                ...(order.items ?? []).map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: InkWell(
                      onTap: () => _openProductDetails(context, item),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FF),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.lightprimery),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: SizedBox(
                                width: 56.w,
                                height: 56.w,
                                child: Image.network(
                                  item.imageUrl ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: AppColors.light,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name ?? 'Item',
                                    style: AppStyle.body6,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Tap image to view details',
                                    style: AppStyle.smallBlack.copyWith(
                                      color: AppColors.light,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'x${item.quantity ?? 1}',
                              style: AppStyle.smallBlack,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${item.subtotal ?? 0} EGP',
                              style: AppStyle.smallPrimery,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openProductDetails(BuildContext context, OrderItemModel item) {
    final productId = item.product?.id;
    if (productId == null || productId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Product details are unavailable for this item',
            style: AppStyle.smallBackground,
                          ),
          backgroundColor: AppColors.ternary,
        ),
      );
      return;
    }

    final product = ProductModelBuyer(
      pId: productId,
      name: item.product?.name ?? item.name,
      price: item.product?.price ?? item.price,
      imageUrl: item.product?.imageUrl ?? item.imageUrl,
      description: item.name ?? 'Product from your order',
    );

    Navigator.pushNamed(
      context,
      RouteNames.product_details_screen,
      arguments: {
        'product': product,
        'cartCubit': getIt<CartCubit>(),
      },
    );
  }

  bool _canCancel(String? status) {
    final normalized = (status ?? '').toLowerCase();
    if (normalized.contains('cancel')) return false;
    if (normalized.contains('deliver')) return false;
    if (normalized.contains('complete')) return false;
    return true;
  }

  void _showCancelOrderDialog(BuildContext context, OrderDataModel order) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Cancel order', style: AppStyle.medBlack),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please provide a reason for cancellation.',
              style: AppStyle.smallBlack,
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Reason',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.primery),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Back', style: AppStyle.smallBlack),
          ),
          TextButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (order.id == null || order.id!.isEmpty) return;
              Navigator.pop(dialogContext);
              context.read<OrderCubit>().cancelOrder(
                order.id!,
                reason.isEmpty ? 'Cancelled by user' : reason,
              );
            },
            child: Text(
              'Confirm cancel',
              style: AppStyle.body6.copyWith(color: AppColors.ternary),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 200.h),
          Icon(
            Icons.shopping_bag_outlined,
            size: 54.sp,
            color: AppColors.light,
          ),
          SizedBox(height: 12.h),
          Center(
            child: Text(
              'No orders yet',
              style: AppStyle.medBlack.copyWith(fontSize: 18.sp),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: Text(
              'Place your first order and it will appear here.',
              style: AppStyle.smallBlack.copyWith(color: AppColors.light),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              '$label:',
              style: AppStyle.smallBlack.copyWith(color: AppColors.light),
            ),
          ),
          Expanded(child: Text(value, style: AppStyle.body6)),
        ],
      ),
    );
  }
}
