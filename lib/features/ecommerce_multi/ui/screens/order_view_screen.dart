import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
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

Future<void> leaveOrdersScreen(
    BuildContext context,
    bool openedFromCart,
    ) async {
  if (openedFromCart) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    return;
  }

  final role = await getIt<SharedPrefHelper>().getSecureData(
    SharedPrefKey.role,
  );
  if (!context.mounted) return;
  final cartRoute = role == 'tailor'
      ? RouteNames.tailor_cart_screen
      : RouteNames.customer_cart_screen;
  Navigator.of(context).pushReplacementNamed(cartRoute);
}

class OrderViewScreen extends StatelessWidget {
  const OrderViewScreen({super.key, this.openedFromCart = false});

  final bool openedFromCart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderCubit>()..getMyOrders(),
      child: PopScope(
        canPop: openedFromCart,
        onPopInvokedWithResult: (didPop, _) async {
          if (!didPop) await leaveOrdersScreen(context, openedFromCart);
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: 'My Orders',
            leading: true,
            showCartIcon: false,
            onCartTap: null,
            onLeadingPressed: () => leaveOrdersScreen(context, openedFromCart),
          ),
          body: const OrderViewBody(),
        ),
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
                content: Text(
                  AppStyle.userMessage(message),
                  style: AppStyle.smallBackground,
                ),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => OrderDetailsBottomSheet(
        order: order,
        canCancel: _canAllCancel(order.subOrders),
        subtotal: _orderSubtotal(order),
        shippingCost: _orderShipping(order),
        items: _allOrderItems(order),
        onCancelOrder: () => _showCancelOrderDialog(context, order),
        onCancelSubOrder: (subOrderId) =>
            _showCancelSubOrderDialog(context, order, subOrderId),
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
      arguments: {'product': product, 'cartCubit': getIt<CartCubit>()},
    );
  }

  bool _canAllCancel(List<SubOrderModel>? subOrders) {
    if (subOrders == null || subOrders.isEmpty) return false;
    return subOrders.every(
          (subOrder) => _isCancellableStatus(subOrder.orderStatus),
    );
  }

  bool _isCancellableStatus(String? status) {
    final normalized = (status ?? '').toLowerCase();
    if (normalized.contains('placed')) return true;
    return false;
  }

  void _showCancelOrderDialog(BuildContext context, OrderDataModel order) {
    if (order.id == null || order.id!.isEmpty) return;
    final cancellableSubOrders = (order.subOrders ?? const <SubOrderModel>[])
        .where(
          (subOrder) =>
      subOrder.id != null &&
          subOrder.id!.isNotEmpty &&
          _isCancellableStatus(subOrder.orderStatus),
    )
        .toList();

    if (cancellableSubOrders.isEmpty) return;

    if (cancellableSubOrders.length == 1) {
      _showCancelSubOrderDialog(context, order, cancellableSubOrders.first.id!);
      return;
    }
  }

  void _showSubOrderPicker(BuildContext context, OrderDataModel order) {
    final cancellableSubOrders = (order.subOrders ?? const <SubOrderModel>[])
        .where(
          (subOrder) =>
      subOrder.id != null &&
          subOrder.id!.isNotEmpty &&
          _isCancellableStatus(subOrder.orderStatus),
    )
        .toList();

    if (cancellableSubOrders.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select sub-order to cancel',
                style: AppStyle.medBlack.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 8.h),
              ...cancellableSubOrders.map(
                    (subOrder) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    subOrder.seller?.name ?? 'Seller',
                    style: AppStyle.body6,
                  ),
                  subtitle: Text(
                    subOrder.orderStatus ?? 'Unknown status',
                    style: AppStyle.smallBlack,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.lightsecondary,
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _showCancelSubOrderDialog(context, order, subOrder.id!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelSubOrderDialog(
      BuildContext context,
      OrderDataModel order,
      String subOrderId,
      ) {
    if (order.id == null || order.id!.isEmpty) return;
    showCancelOrderDialog(
      context: context,
      onConfirm: (reason) {
        context.read<OrderCubit>().cancelSubOrder(
          order.id!,
          subOrderId,
          reason.isEmpty ? 'Cancelled by user' : reason,
        );
      },
    );
  }
}
