import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/circle_indicator.dart';
import 'package:chicora/features/profile/data/model/profile_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// Top-of-screen profile row: avatar, name/email, tailor workshop + maps, edit.
class ProfileIdentityHeader extends StatelessWidget {
  const ProfileIdentityHeader({
    super.key,
    required this.profile,
    required this.isLoading,
    required this.primaryColor,
    required this.darkColor,
    required this.lightColor,
    required this.onEditProfile,
  });

  final ProfileResponse? profile;
  final bool isLoading;
  final Color primaryColor;
  final Color darkColor;
  final Color lightColor;
  final void Function(ProfileResponse profile) onEditProfile;

  /// Driving directions from the user's current location to the workshop.
  /// Tries HTTPS Maps directions, then `geo:`, then the original [mapsUrl].
  Future<void> _openMapsDirections(
    BuildContext context,
    String mapsUrl,
    String? address,
  ) async {
    final trimmed = mapsUrl.trim();
    final dest = _sanitizeDirDestination(
      _directionsDestination(trimmed, address?.trim()),
    );

    Future<bool> openExternal(Uri u) =>
        launchUrl(u, mode: LaunchMode.externalApplication);

    var ok = false;

    if (dest != null && dest.isNotEmpty) {
      final https = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=${Uri.encodeComponent(dest)}'
        '&travelmode=driving',
      );
      ok = await openExternal(https);

      if (!ok && !kIsWeb) {
        final geo = Uri.parse('geo:0,0?q=${Uri.encodeComponent(dest)}');
        ok = await openExternal(geo);
      }
    }

    if (!ok) {
      final raw = Uri.tryParse(trimmed);
      if (raw != null) {
        ok = await openExternal(raw);
      }
    }

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open Maps')));
    }
  }

  /// Avoid passing another URL as `destination` (breaks the Maps app parser).
  static String? _sanitizeDirDestination(String? dest) {
    if (dest == null) return null;
    final t = dest.trim();
    if (t.isEmpty) return null;
    final lower = t.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return null;
    }
    return t;
  }

  /// Best-effort destination string for Google Maps directions URL (api=1).
  static String? _directionsDestination(String mapsUrl, String? address) {
    final fromAt = RegExp(
      r'@(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)',
    ).firstMatch(mapsUrl);
    if (fromAt != null) {
      return '${fromAt.group(1)},${fromAt.group(2)}';
    }

    final parsed = Uri.tryParse(mapsUrl);
    if (parsed != null) {
      final ll = parsed.queryParameters['ll'];
      if (ll != null && ll.isNotEmpty) {
        final parts = ll.split(',');
        if (parts.length == 2) {
          final a = parts[0].trim();
          final b = parts[1].trim();
          if (a.isNotEmpty && b.isNotEmpty) return '$a,$b';
        }
      }
      final q = parsed.queryParameters['q'];
      if (q != null && q.isNotEmpty) return q;
    }

    if (address != null && address.isNotEmpty) return address;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final tailor = p?.role.toLowerCase() == 'tailor';

    final loc = tailor ? p?.location?.trim() : null;
    final hasLoc = loc != null && loc.isNotEmpty;

    final maps = tailor ? p?.mapsUrl?.trim() : null;
    final hasMaps = maps != null && maps.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 130.h,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45.r,
            backgroundColor: lightColor,
            backgroundImage: p?.imageUrl != null
                ? NetworkImage(p!.imageUrl!)
                : null,
            child: p?.imageUrl == null
                ? Icon(Icons.person, size: 45.sp, color: primaryColor)
                : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: isLoading
                ? Center(child: circleIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p?.name ?? "—", style: AppStyle.medBlack),
                      SizedBox(height: 4.h),
                      Text(
                        p?.email ?? "—",
                        style: AppStyle.medLight.copyWith(fontSize: 14),
                      ),
                      if (hasLoc)
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.place_outlined,
                                size: 16.sp,
                                color: darkColor,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  loc,
                                  style: AppStyle.medLight.copyWith(
                                    fontSize: 13.sp,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (hasMaps)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: primaryColor,
                              minimumSize: Size.zero,
                            ),
                            onPressed: () =>
                                _openMapsDirections(context, maps, loc),
                            icon: Icon(Icons.map_outlined, size: 18.sp),
                            label: Text(
                              'Open workshop on Maps',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 6.h),
                    ],
                  ),
          ),
          IconButton(
            onPressed: p == null ? null : () => onEditProfile(p),
            icon: Icon(Icons.edit, size: 28.sp, color: primaryColor),
          ),
        ],
      ),
    );
  }
}
