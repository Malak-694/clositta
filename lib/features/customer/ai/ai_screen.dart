import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/chat/logic/conversations_cubit/conversations_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/route_names.dart';
import '../../../core/widgets/custom_app_bar.dart';
import 'complete_recommend/ui/widgets/option_card.dart';

class AiCustomerScreen extends StatefulWidget {
  AiCustomerScreen({super.key});

  @override
  State<AiCustomerScreen> createState() => _AiCustomerScreenState();
}

class _AiCustomerScreenState extends State<AiCustomerScreen> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    context.read<ConversationsCubit>().loadUnreadCount();
  }

  Future<void> _loadUserId() async {
    final prefs = getIt<SharedPrefHelper>();
    final id = await prefs.getSecureData(SharedPrefKey.id);
    if (!mounted) return;
    setState(() => _currentUserId = id);
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = cartTotalItemQuantity(context.watch<CartCubit>().state);
    final chatCount = context.watch<ConversationsCubit>().unreadCount;
    final notifCount = context.read<NotificationCubit>().unreadCount;

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: CustomAppBar(
        title: 'Welcome to Clositta',
        showCartIcon: true,
        cartItemCount: cartCount,
        onCartTap: () =>
            Navigator.pushNamed(context, RouteNames.customer_cart_screen),
        showNotificationIcon: true,
        unreadNotificationCount: notifCount,
        onNotificationTap: () =>
            Navigator.pushNamed(context, RouteNames.notification_screen),
        showChatIcon: true,
        unreadChatCount: chatCount,
        onChatTap: () => Navigator.pushNamed(
          context,
          RouteNames.conversations_screen,
          arguments: {'currentUserId': _currentUserId ?? ''},
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Row(
                children: [
                  Container(
                    width: 80.h,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Using a smooth gradient for a modern look
                      gradient: LinearGradient(
                        colors: [
                          AppColors.darkPrimaryLight,
                          AppColors.darkPrimary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.face_4_outlined,
                        size: 50.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Text(
                    "Hello,\nHow can I help you today?",
                    style: AppStyle.medBlack,
                  ),
                ],
              ),

              const SizedBox(height: 35),

              AiOptionCard(
                title: "Bring your Idea into life",
                subtitle: "Describe your fashion idea and let AI create it.",
                number: 1,
                color: Colors.orange.shade100,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.generate_image_screen,
                  );
                },
              ),

              const SizedBox(height: 18),

              AiOptionCard(
                title: "Generate an outfit together",
                subtitle: "Create a complete outfit with AI suggestions.",
                number: 2,
                color: Colors.purple.shade100,
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.outfit_recomendation);
                },
              ),

              const SizedBox(height: 18),

              AiOptionCard(
                title: "Complete an outfit with amazing items",
                subtitle: "Find matching pieces for your existing outfit.",
                number: 3,
                color: Colors.green.shade100,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.complete_outfit_screen,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'customer',
        selectedIndex: 1,
      ),
    );
  }
}
