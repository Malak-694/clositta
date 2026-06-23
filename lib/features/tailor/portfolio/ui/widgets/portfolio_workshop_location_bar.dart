import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/tailor/portfolio/data/models/portfolio_tailor_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/router/route_names.dart';

/// Tailor workshop address and Maps link, shown at the top of the portfolio screen.
class PortfolioWorkshopLocationBar extends StatelessWidget {
  const PortfolioWorkshopLocationBar({super.key, required this.tailor});

  final PortfolioTailorUserModel? tailor;

  Future<void> _openMaps(BuildContext context, String raw) async {
    final uri = Uri.tryParse(raw);
    if (uri == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid maps link')));
      return;
    }
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = tailor;
    if (t == null) return const SizedBox.shrink();

    final loc = t.location?.trim();
    final map = t.mapsUrl?.trim();
    final hasLoc = loc != null && loc.isNotEmpty;
    final hasMap = map != null && map.isNotEmpty;

    return Material(
      color: AppColors.lightsecondary.withValues(alpha: 0.25),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.secondary.withValues(alpha: 0.35),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Workshop location',
                  style: AppStyle.medSecondary.copyWith(fontSize: 12.sp),
                ),
                if (hasMap)
                  TextButton.icon(
                    onPressed: () => _openMaps(context, map),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: AppColors.secondary,
                    ),
                    icon: Icon(Icons.map_outlined, size: 18.sp),
                    label: Text(
                      'Open in Maps',
                      style: AppStyle.medSecondary.copyWith(fontSize: 13.sp),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            if (hasLoc)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.place_outlined,
                    size: 20.sp,
                    color: AppColors.secondary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      loc,
                      style: AppStyle.medBlack.copyWith(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),

            SizedBox(height: 10.h),
            if (t.averageRating != null)
              Row(
                children: [
                  Icon(Icons.star, size: 14.sp, color: AppColors.secondary),
                  SizedBox(width: 6.w),
                  Text(
                    '${t.averageRating!.toStringAsFixed(1)}',
                    style: AppStyle.medBlack.copyWith(fontSize: 13.sp),
                  ),
                  if (t.totalRatings != null) ...[
                    SizedBox(width: 6.w),
                    Text(
                      '(${t.totalRatings})',
                      style: AppStyle.medLight.copyWith(fontSize: 12.sp),
                    ),
                  ],
                ],
              ),
            if (!hasLoc && !hasMap)
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteNames.profile_tailor_screen,
                ),
                child: Text(
                  'No address yet — tap here to add workshop details from edit profile.',
                  style: AppStyle.smallPrimery.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
