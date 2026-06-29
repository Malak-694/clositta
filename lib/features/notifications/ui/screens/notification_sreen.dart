import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/features/notifications/data/models/notification_model.dart';
import 'package:chicora/features/notifications/data/models/notifications_list_response.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationCubit>()..getNotifications(),
      child: const _NotificationScreenBody(),
    );
  }
}

class _NotificationScreenBody extends StatelessWidget {
  const _NotificationScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        leading: true,
        title: 'Notifications',
        showCartIcon: false,
        onCartTap: () {},
        extraActions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final cubit = context.read<NotificationCubit>();
              final hasUnread = cubit.notifications.any((n) => !n.isRead);
              if (!hasUnread) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => cubit.markAllAsRead(),
                child: Text(
                  'Mark all read',
                  style: AppStyle.medBackground.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.background,
                    fontSize: 12.sp ,
                  ),
                ),
              );
            },
          ),
          // Preferences icon
          IconButton(
            icon: const Icon(Icons.tune_outlined , color: AppColors.background,),
            tooltip: 'Notification preferences',
            onPressed: () => Navigator.pushNamed(
              context,
              RouteNames.notification_preferences_screen,
            ),
          ),
        ],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          state.whenOrNull(
            fail: (msg) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: AppColors.ternary),
            ),
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primery),
            ),
            fail: (_) => _ErrorView(
              onRetry: () =>
                  context.read<NotificationCubit>().getNotifications(),
            ),
            success: (data) {
              if (data is! NotificationsListResponse) {
                final notifications = context
                    .read<NotificationCubit>()
                    .notifications;
                return _NotificationList(notifications: notifications);
              }
              if (data.notifications.isEmpty) {
                return const _EmptyView();
              }
              return _NotificationList(notifications: data.notifications);
            },
          );
        },
      ),
    );
  }
}

// ── List ───────────────────────────────────────────────────────────────────

class _NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  const _NotificationList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) return const _EmptyView();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        color: AppColors.primery,
        onRefresh: () => context.read<NotificationCubit>().getNotifications(),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: notifications.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: AppColors.lightprimery, indent: 72.w),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationTile(
              notification: notification,
              onTap: () {
                if (!notification.isRead) {
                  context.read<NotificationCubit>().markAsRead(notification.id);
                }
              },
              onDelete: () => context
                  .read<NotificationCubit>()
                  .deleteNotification(notification.id),
            );
          },
        ),
      ),
    );
  }
}


class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 72.sp,
            color: AppColors.lightprimery,
          ),
          SizedBox(height: 16.h),
          Text('No notifications yet', style: AppStyle.medGray),
          SizedBox(height: 8.h),
          Text("You're all caught up!", style: AppStyle.body5),
        ],
      ),
    );
  }
}


class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: AppColors.light),
          SizedBox(height: 12.h),
          Text('Failed to load notifications', style: AppStyle.body5),
          SizedBox(height: 12.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primery,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
