import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/constants.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/seller/orders/data/models/order_seller_response_model.dart';
import 'package:chicora/features/seller/orders/logic/cubit/order_mangement_cubit.dart';
import 'package:chicora/features/seller/orders/logic/cubit/order_mangement_state.dart';
import 'package:chicora/features/seller/orders/ui/widgets/seller_order_status_filter_bar.dart';
import 'package:chicora/features/seller/orders/ui/widgets/seller_orders_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderMangementScreen extends StatelessWidget {
  const OrderMangementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Orders',
        showCartIcon: false,
        onCartTap: () {},
      ),
      body: BlocProvider(
        create: (_) => getIt<OrderMangementCubit>()..getAllOrdersSeller(),
        child: const _OrderMangementBody(),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'seller',
        selectedIndex: 1,
      ),
    );
  }
}

class _OrderMangementBody extends StatefulWidget {
  const _OrderMangementBody();

  @override
  State<_OrderMangementBody> createState() => _OrderMangementBodyState();
}

class _OrderMangementBodyState extends State<_OrderMangementBody> {
  List<OrderSellerResponseModel> _orders = [];
  String? _statusFilter;
  /// After the first successful fetch, filter/refresh loads use inline progress only.
  bool _hasCompletedFirstLoad = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderMangementCubit, OrderMangementState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            if (data is List<OrderSellerResponseModel>) {
              setState(() {
                _orders = List<OrderSellerResponseModel>.from(data);
                _hasCompletedFirstLoad = true;
              });
            }
          },
          fail: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStyle.userMessage(message))),
            );
          },
        );
      },
      builder: (context, state) {
        final loading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final failMessage = state.maybeWhen(
          fail: (m) => m,
          orElse: () => null,
        );

        if (loading && !_hasCompletedFirstLoad) {
          return const Center(child: CircularProgressIndicator());
        }

        if (failMessage != null && _orders.isEmpty && !_hasCompletedFirstLoad) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(kHorizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    failMessage,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  FilledButton(
                    onPressed: () => context.read<OrderMangementCubit>().getAllOrdersSeller(
                          status: _statusFilter,
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            kHorizontalPadding,
            0,
            kHorizontalPadding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              SellerOrderStatusFilterBar(
                selectedStatus: _statusFilter,
                onStatusSelected: (value) {
                  setState(() => _statusFilter = value);
                  context.read<OrderMangementCubit>().getAllOrdersSeller(
                        status: value,
                      );
                },
              ),
              SizedBox(height: 12.h),
              if (loading) const LinearProgressIndicator(minHeight: 2),
              SizedBox(height: 8.h),
              Expanded(
                child: SellerOrdersListWidget(
                  orders: _orders,
                  onRefresh: () async {
                    await context.read<OrderMangementCubit>().getAllOrdersSeller(
                          status: _statusFilter,
                        );
                  },
                  onUpdateStatus: (order,
                      {orderStatus, paymentStatus}) async {
                    final id = order.resolvedOrderId;
                    final subOrderId = order.resolvedSubOrderId;
                    if (id == null || subOrderId == null) return;
                    await context.read<OrderMangementCubit>().updateOrderStatusSeller(
                          orderId: id,
                          suborderId: subOrderId,
                          orderStatus: orderStatus,
                          paymentStatus: paymentStatus,
                        );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
