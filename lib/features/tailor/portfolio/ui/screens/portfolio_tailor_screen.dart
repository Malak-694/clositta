import 'package:chicora/features/ecommerce_multi/ui/widgets/comment_section_widget.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import '../../../../chat/data/models/conversation_model.dart';
import '../../../../chat/logic/conversations_cubit/conversations_cubit.dart';
import '../../../../chat/logic/conversations_cubit/conversations_state.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_state.dart';
import '../../../../ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import '../../../../notifications/data/models/unread_count_response.dart';
import '../../../../notifications/logic/cubit/notification_cubit.dart';
import '../../data/repo/portfolio_tailor_repo.dart';
import '../../logic/cubit/portfolio_tailor_cubit.dart';
import '../../logic/cubit/portfolio_tailor_state.dart';
import '../widgets/portfolio_tailor_body.dart';
import '../widgets/portfolio_workshop_location_bar.dart';

class PortfolioTailorScreen extends StatelessWidget {
  const PortfolioTailorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = getIt<SharedPrefHelper>();
    final cartCount = cartTotalItemQuantity(context.watch<CartCubit>().state);
    final chatCount = context.watch<ConversationsCubit>().unreadCount;
    final notifCount = context.watch<NotificationCubit>().state.maybeWhen(
      success: (data) => data is UnreadCountResponse ? data.unreadCount : 0,
      orElse: () => 0,
    );

    return BlocProvider(
      create: (context) => PortfolioTailorCubit(
        portfolioTailorRepo: getIt<PortfolioTailorRepo>(),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'My Portfolio',
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
          onChatTap: () async {
            final userId = await prefs.getSecureData('id') ?? '';
            Navigator.pushNamed(
              context,
              RouteNames.conversations_screen,
              arguments: {'currentUserId': userId ?? ''},
            );
          },
        ),
        body: BlocBuilder<PortfolioTailorCubit, PortfolioTailorState>(
          builder: (context, state) {
            final tailor = context.read<PortfolioTailorCubit>().tailorSummary;
            final ratings = tailor?.ratings;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PortfolioWorkshopLocationBar(tailor: tailor),
                Expanded(
                  child: PortfolioTailorBody(
                    reviewsSection: ratings == null
                        ? null
                        : CommentSection(
                      productComments: ratings,
                      userRating: null,
                      currentUserId: null,
                      accent: AppColors.lightsecondary,
                      accentDark: AppColors.darksecondary,
                      onDelete: null,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: FloatingNavBar(
          userRole: 'tailor',
          selectedIndex: 2,
        ),
      ),
    );
  }
}
