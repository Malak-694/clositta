import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading = false,
    this.leadingIcon = Icons.arrow_back_ios,
    this.style,
    required this.showCartIcon,
    this.cartItemCount = 0,
    required this.onCartTap,
    this.extraActions = const [], // ✅ new
    this.onLeadingPressed,
    this.showChatIcon = false,
    this.unreadChatCount = 0,
    this.onChatTap,
  });

  final String title;
  final bool leading;
  final IconData leadingIcon;
  final TextStyle? style;
  final bool showCartIcon;
  final int cartItemCount;
  final VoidCallback? onCartTap;
  final List<Widget> extraActions; // ✅ new
  final VoidCallback? onLeadingPressed;
 final bool showChatIcon;
  final int unreadChatCount;
  final VoidCallback? onChatTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.primery,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading)
            IconButton(
              icon: Icon(leadingIcon, color: AppColors.background),
              onPressed: onLeadingPressed ?? () => Navigator.pop(context),
            ),
          FutureBuilder<String?>(
            future: getIt<SharedPrefHelper>().getSecureData(SharedPrefKey.role),
            builder: (context, snapshot) {
              final String role = snapshot.data ?? '';
              final TextStyle resolvedStyle = style ?? _styleForRole(role);
              return Text(title, style: resolvedStyle);
            },
          ),
        ],
      ),
      actions: [
        ...extraActions,

        if (showChatIcon)
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.background,
                  ),
                  onPressed: onChatTap,
                ),
                if (unreadChatCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadChatCount > 99 ? '99+' : '$unreadChatCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Cart icon
        if (showCartIcon)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.background,
                  ),
                  onPressed: onCartTap,
                ),
                if (cartItemCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cartItemCount > 99 ? '99+' : '$cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

TextStyle _styleForRole(String role) {
  switch (role) {
    case 'customer':
      return AppStyle.medBackground;
    case 'tailor':
      return AppStyle.medBackground;
    case 'clothes_seller':
      return AppStyle.medBackground;
    case 'material_seller':
      return AppStyle.medBackground;
    case 'admin':
      return AppStyle.medBackground.copyWith(color: Colors.red);
    default:
      return AppStyle.medBackground;
  }
}