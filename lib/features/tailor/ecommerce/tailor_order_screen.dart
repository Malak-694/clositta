import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_cubit.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/order_view_screen.dart'
    show OrderViewBody;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TailorOrderScreen extends StatelessWidget {
  const TailorOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Welcome to Clositta",
        showCartIcon: true,
        onCartTap: () =>
            Navigator.pushNamed(context, RouteNames.tailor_cart_screen),
      ),
      body: BlocProvider(
        create: (_) => getIt<OrderCubit>()..getMyOrders(),
        child: const OrderViewBody(),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'tailor',
        selectedIndex: 3,
      ),
    );
  }
}
