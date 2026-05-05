import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/features/ecommerce_multi/data/models/cart_models/cart_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_request_model.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_state.dart';
import 'package:chicora/features/ecommerce_multi/ui/widgets/checkout_form_section.dart';
import 'package:chicora/features/ecommerce_multi/ui/widgets/order_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: "Checkout",
        leading: true,
        showCartIcon: false,
        onCartTap: null,
      ),
      body: const CheckoutScreenBody(),
    );
  }
}

class CheckoutScreenBody extends StatefulWidget {
  const CheckoutScreenBody({super.key});

  @override
  State<CheckoutScreenBody> createState() => _CheckoutScreenBodyState();
}

class _CheckoutScreenBodyState extends State<CheckoutScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _governorateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _notesController = TextEditingController();
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

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _governorateController.dispose();
    _postalCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double _calculateSubtotal(List<Item>? items) {
    if (items == null) return 0;
    return items.fold(
      0,
      (sum, item) => sum + (item.priceAtAddTime ?? 0) * (item.quantity ?? 1),
    );
  }

  void _submitOrder() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<OrderCubit>().placeOrder(
      OrderRequestModel(
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        governorate: _governorateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
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
                    data.message ?? 'Order placed successfully',
                    style: AppStyle.smallBackground,
                  ),
                  backgroundColor: _rolePrimary,
                ),
              );
              context.read<CartCubit>().getCart();
              Navigator.pop(context);
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
      builder: (context, orderState) {
        final bool isSubmitting = orderState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        return BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            List<Item> items = [];
            cartState.whenOrNull(
              success: (data) {
                if (data is CartResponseModel) {
                  items = data.items ?? [];
                }
              },
            );
            final subtotal = _calculateSubtotal(items);

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping Details',
                      style: AppStyle.medBlack.copyWith(fontSize: 20.sp),
                    ),
                    SizedBox(height: 12.h),
                    CheckoutFormSection(
                      fullNameController: _fullNameController,
                      phoneController: _phoneController,
                      addressController: _addressController,
                      cityController: _cityController,
                      governorateController: _governorateController,
                      postalCodeController: _postalCodeController,
                      notesController: _notesController,
                      labelColor: _roleDark,
                      fillColor: _rolePrimary.withOpacity(0.06),
                      enabledBorderColor: _rolePrimary.withOpacity(0.3),
                      focusedBorderColor: _rolePrimary,
                    ),
                    SizedBox(height: 16.h),
                    OrderSummary(
                      subtotal: subtotal,
                      backgroundColor: _rolePrimary.withOpacity(0.12),
                      accentColor: _roleDark,
                    ),
                    SizedBox(height: 20.h),
                    isSubmitting
                        ? Center(
                            child: CircularProgressIndicator(
                              color: _rolePrimary,
                            ),
                          )
                        : Center(
                            child: CustomElevatedButton(
                              value: 'Place Order',
                              height: 52.h,
                              background: _rolePrimary,
                              style: AppStyle.medBackground.copyWith(
                                fontSize: 18.sp,
                              ),
                              onPressed: _submitOrder,
                            ),
                          ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
