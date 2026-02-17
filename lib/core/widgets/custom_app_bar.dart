import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading = false,
    this.leadingIcon = Icons.arrow_back_ios,
  });
  final String title;
  final bool leading;
  final IconData leadingIcon;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      automaticallyImplyLeading: false, // Disable default back button
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading)
            IconButton(
              icon: Icon(leadingIcon, color: AppColors.dark),
              onPressed: () => Navigator.pop(context),
            ),
          Text(
            title,
            style: AppStyle.boldSecondary.copyWith(
              fontSize: 30.sp,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.5
                ..color = const Color.fromARGB(255, 82, 66, 184),
            ),
          ),
        ],
      ),
    );
  }
}
