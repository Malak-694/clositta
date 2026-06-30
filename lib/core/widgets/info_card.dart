import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? location;
  final String? email;
  final double? rating;
  final int? reviewCount;
  final String? mapUrl;

  const InfoCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.location,
    this.rating,
    this.reviewCount,
    this.email,
    this.mapUrl,
  });
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.lightprimery,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : null,
                child: imageUrl == null
                    ? Icon(Icons.person, color: AppColors.primery, size: 28)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppStyle.medBlack),
                  if (email != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.email, size: 16, color: AppColors.light),
                        const SizedBox(width: 3),
                        Text(email!, style: AppStyle.body6),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
            child: Column(
              children: [
                // email
                if (location != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: AppColors.light),
                      const SizedBox(width: 2),
                      Text(location!, style: AppStyle.medBlack, softWrap: true),
                      Spacer(),
                      if (mapUrl != null)
                        TextButton.icon(
                          onPressed: () => _openMaps(context, mapUrl!.trim()),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: AppColors.secondary,
                          ),
                          icon: Icon(Icons.map_outlined, size: 18.sp),
                          label: Text(
                            'Open in Maps',
                            style: AppStyle.medSecondary.copyWith(
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],

                // Rating (optional)
                if (rating != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        rating!.toStringAsFixed(1),
                        style: AppStyle.medBlack,
                      ),
                      if (reviewCount != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          "(${reviewCount!} reviews)",
                          style: TextStyle(
                            color: AppColors.light,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
