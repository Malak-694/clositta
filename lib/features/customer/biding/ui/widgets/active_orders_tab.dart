import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/circle_indicator.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/pinterest_grid.dart';
import 'package:chicora/core/widgets/pinterest_grid_config.dart';
import 'package:chicora/features/customer/biding/data/models/offer_model.dart';
import 'package:chicora/features/customer/biding/ui/widgets/rate_tailor_bottom_sheet.dart';
import 'package:chicora/features/customer/biding/ui/widgets/state_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/router/route_names.dart';
import '../../logic/cubit/customer_offer_cubit/customer_offers_cubit.dart';
import '../../logic/cubit/customer_offer_cubit/customer_offers_state.dart';
import 'cutsom_button.dart';
import 'deadline_badge.dart';

class ActiveOrdersTab extends StatefulWidget {
  const ActiveOrdersTab({super.key});

  @override
  State<ActiveOrdersTab> createState() => _ActiveOrdersTabState();
}

class _ActiveOrdersTabState extends State<ActiveOrdersTab> {
  CustomerOffersCubit? cubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit ??= context.read<CustomerOffersCubit>();
  }

  String _formatDate(dynamic dateValue) {
    try {
      final dateTime = dateValue is DateTime
          ? dateValue
          : DateTime.parse(dateValue as String);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return 'N/A';
    }
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'in_progress':
        return const Color(0xFFFF9500);
      case 'completed':
        return Colors.green.shade400;
      default:
        return AppColors.primery;
    }
  }

  String _statusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Accepted';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
      child: BlocConsumer<CustomerOffersCubit, AcceptedOffersState>(
        listener: (context, state) {
          state.whenOrNull(
            fail: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.red),
              );
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => Center(child: circleIndicator()),
            loading: () => Center(child: circleIndicator()),
            fail: (msg) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Failed to retrieve active orders'),
                  const SizedBox(height: 8),
                  CustomElevatedButton(
                    onPressed: () => context
                        .read<CustomerOffersCubit>()
                        .refreshAcceptedOffers(),
                    value: 'Retry',
                  ),
                ],
              ),
            ),
            success: (offers) {
              if (offers.isEmpty) {
                return Center(
                  child: Text('No active orders', style: AppStyle.medLight),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: offers.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final offer = offers[index];

                  final tailorName = offer.tailor?.name ?? 'Unknown Tailor';
                  final workStatus = offer.workStatus ?? 'accepted';
                  final receiverId = offer.tailor?.id;
                  final canOpenChat =
                      receiverId != null && receiverId.isNotEmpty;
                  final isCompleted = workStatus.toLowerCase() == 'completed';

                  final description = offer.bid?.requestDescription ?? '';

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.lightprimery,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                description,
                                style: AppStyle.medBlack,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(workStatus),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                _statusLabel(workStatus),
                                style: AppStyle.smallBackground,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            final tailor = offer.tailor;
                            if (tailor == null) return;
                            Navigator.pushNamed(
                              context,
                              RouteNames.tailor_info_screen,
                              arguments: {
                                'tailorId': tailor.id ?? '',
                                'name': tailor.name ?? 'Unknown Tailor',
                                'email': tailor.email,
                                'imageUrl': null,
                                'location': null,
                                'rating': null,
                                'reviewCount': null,
                              },
                            );
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20.r,
                                backgroundColor: AppColors.lightprimery,
                                child: Text(
                                  (tailorName.isNotEmpty ? tailorName[0] : '?')
                                      .toUpperCase(),
                                  style: AppStyle.smallPrimery,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tailorName,
                                      style: AppStyle.smallPrimery,
                                    ),
                                    Text(
                                      'Tap to view profile',
                                      style: AppStyle.body5.copyWith(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12.sp,
                                color: AppColors.primery,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: StateBox(
                                label: 'Price',
                                value: offer.price != null
                                    ? '${offer.price} EGP'
                                    : '—',
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: StateBox(
                                label: 'Duration',
                                value: offer.timeInDays != null
                                    ? '${offer.timeInDays} days'
                                    : '—',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        if (offer.deadline != null) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 13.sp,
                                color: AppColors.light,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'Deadline',
                                style: AppStyle.body5.copyWith(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                _formatDate(offer.deadline!),
                                style: AppStyle.smallPrimery,
                              ),
                              const Spacer(),
                              DeadlineBadge(deadline: offer.deadline!),
                            ],
                          ),
                          SizedBox(height: 10.h),
                        ],
                        if (offer.message != null &&
                            offer.message!.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 13.sp,
                                color: AppColors.light,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "Tailor's note",
                                style: AppStyle.body5.copyWith(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.lightprimery.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              offer.message!,
                              style: AppStyle.smallPrimery,
                            ),
                          ),
                          SizedBox(height: 14.h),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Chat',
                                icon: Icons.chat_bubble_outline_rounded,
                                backgroundColor: AppColors.lightprimery,
                                foregroundColor: AppColors.primery,
                                width: double.infinity,
                                height: 40,
                                onPressed: canOpenChat
                                    ? () => Navigator.pushNamed(
                                        context,
                                        RouteNames.chat_screen,
                                        arguments: {
                                          'receiverId': receiverId,
                                          'receiverName':
                                              offer.tailor?.name ?? '',
                                        },
                                      )
                                    : null,
                              ),
                            ),
                            if (isCompleted) ...[
                              SizedBox(width: 10.w),
                              Expanded(
                                child: CustomButton(
                                  text: 'Rate',
                                  icon: Icons.star_rounded,
                                  backgroundColor: AppColors.lightsecondary,
                                  foregroundColor: AppColors.secondary,
                                  width: double.infinity,
                                  height: 40,
                                  onPressed: offer.id == null
                                      ? null
                                      : () async {
                                          final rated =
                                              await showRateTailorSheet(
                                                context: context,
                                                offerId: offer.id!,
                                                tailorName: tailorName,
                                                onSubmit:
                                                    (rating, comment) async =>
                                                        cubit?.rateOffer(
                                                          offerId: offer.id!,
                                                          rating: rating,
                                                          comment: comment,
                                                        ),
                                              );
                                          if (rated == true &&
                                              context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  'Rating submitted successfully!',
                                                ),
                                                backgroundColor:
                                                    Colors.green.shade400,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.r,
                                                      ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
