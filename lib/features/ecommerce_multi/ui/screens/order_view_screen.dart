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
import 'package:chicora/features/ecommerce_multi/ui/widgets/empty_orders_widget.dart';
import 'package:chicora/features/ecommerce_multi/ui/widgets/order_card_widget.dart';
import 'package:chicora/features/ecommerce_multi/ui/widgets/order_cancel_dialog.dart';
import 'package:chicora/features/ecommerce_multi/ui/widgets/order_details_bottom_sheet.dart';
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
  
  
  List<OrderItemModel> _allOrderItems(OrderDataModel order) {
    final subOrders = order.subOrders;
    if (subOrders == null || subOrders.isEmpty) return const [];
    return subOrders
        .expand((subOrder) => subOrder.items ?? const <OrderItemModel>[])
        .toList();
  }

  double _orderSubtotal(OrderDataModel order) {
    final subOrders = order.subOrders;
    if (subOrders == null || subOrders.isEmpty) return 0;
    return subOrders.fold<double>(
      0,
      (sum, subOrder) => sum + (subOrder.itemsTotal ?? 0),
    );
  }

  double _orderShipping(OrderDataModel order) {
    final subOrders = order.subOrders;
    if (subOrders == null || subOrders.isEmpty) return 0;
    return subOrders.fold<double>(
      0,
      (sum, subOrder) => sum + (subOrder.shippingFee ?? 0),
    );
  }

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
              return EmptyOrdersWidget(
                onRefresh: () => context.read<OrderCubit>().getMyOrders(),
              );
            }
            if (data.isEmpty) {
              return EmptyOrdersWidget(
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
          fail: (_) => EmptyOrdersWidget(
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
      builder: (_) => OrderDetailsBottomSheet(
        order: order,
        canCancel: _canCancel(order.subOrders),
        subtotal: _orderSubtotal(order),
        shippingCost: _orderShipping(order),
        items: _allOrderItems(order),
        onCancelOrder: () => _showCancelOrderDialog(context, order),
        onItemTap: (item) => _openProductDetails(context, item),
      ),
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

  bool _canCancel(List<SubOrderModel>? subOrders) {
    if (subOrders == null || subOrders.isEmpty) return false;
    return subOrders.every((subOrder) => _isCancellableStatus(subOrder.orderStatus));
  }

  bool _isCancellableStatus(String? status) {
    final normalized = (status ?? '').toLowerCase();
    if (normalized.contains('cancel')) return false;
    if (normalized.contains('deliver')) return false;
    if (normalized.contains('complete')) return false;
    return true;
  }

  void _showCancelOrderDialog(BuildContext context, OrderDataModel order) {
    showCancelOrderDialog(
      context: context,
      onConfirm: (reason) {
        if (order.id == null || order.id!.isEmpty) return;
        context.read<OrderCubit>().cancelOrder(
          order.id!,
          reason.isEmpty ? 'Cancelled by user' : reason,
        );
      },
    );
  }
}
