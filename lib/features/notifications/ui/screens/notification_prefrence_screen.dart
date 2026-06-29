import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/features/notifications/data/models/notification_preferences.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/preference_tile.dart';

class NotificationPreferencesScreen extends StatelessWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationCubit>()..getNotificationPreferences(),
      child: const _PreferencesBody(),
    );
  }
}

class _PrefItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool Function(_PreferencesBodyState s) getValue;
  final void Function(_PreferencesBodyState s, bool v) setValue;

  const _PrefItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.getValue,
    required this.setValue,
  });
}

List<_PrefItem> _itemsForRole(String? role) {
  const orderTile = _PrefItem(
    icon: Icons.shopping_bag_outlined,
    iconColor: AppColors.secondary,
    title: 'Order Updates',
    subtitle: 'Status changes, confirmations, and shipping updates',
    getValue: _getOrder,
    setValue: _setOrder,
  );
  const bidTile = _PrefItem(
    icon: Icons.gavel_outlined,
    iconColor: AppColors.primery,
    title: 'Bid Updates',
    subtitle: 'New bids placed on your posts and bid results',
    getValue: _getBid,
    setValue: _setBid,
  );
  const offerTile = _PrefItem(
    icon: Icons.local_offer_outlined,
    iconColor: AppColors.darksecondary,
    title: 'Offer Updates',
    subtitle: 'New offers, acceptances, and counter-offers',
    getValue: _getOffer,
    setValue: _setOffer,
  );
  const stockTile = _PrefItem(
    icon: Icons.inventory_2_outlined,
    iconColor: AppColors.ternary,
    title: 'Low Stock Alerts',
    subtitle: 'Get notified when your product stock is running low',
    getValue: _getStock,
    setValue: _setStock,
  );

  switch (role?.toLowerCase()) {
    case 'tailor':
      return [orderTile, bidTile, offerTile];
    case 'clothes_seller':
    case 'material_seller':
    case 'seller':
      return [orderTile, stockTile];
    default:
      return [orderTile, bidTile, offerTile];
  }
}

bool _getOrder(_PreferencesBodyState s) => s._orderUpdates;
bool _getBid(_PreferencesBodyState s) => s._bidUpdates;
bool _getOffer(_PreferencesBodyState s) => s._offerUpdates;
bool _getStock(_PreferencesBodyState s) => s._lowStockAlerts;

void _setOrder(_PreferencesBodyState s, bool v) => s._orderUpdates = v;
void _setBid(_PreferencesBodyState s, bool v) => s._bidUpdates = v;
void _setOffer(_PreferencesBodyState s, bool v) => s._offerUpdates = v;
void _setStock(_PreferencesBodyState s, bool v) => s._lowStockAlerts = v;

class _PreferencesBody extends StatefulWidget {
  const _PreferencesBody();

  @override
  State<_PreferencesBody> createState() => _PreferencesBodyState();
}

class _PreferencesBodyState extends State<_PreferencesBody> {
  bool _orderUpdates = true;
  bool _bidUpdates = true;
  bool _offerUpdates = true;
  bool _lowStockAlerts = true;
  bool _initialised = false;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final role = await getIt<SharedPrefHelper>().getSecureData(
      SharedPrefKey.role,
    );
    if (!mounted) return;
    setState(() => _role = role);
  }

  void _initFromPrefs(NotificationPreferences prefs) {
    if (_initialised) return;
    _orderUpdates = prefs.orderUpdates;
    _bidUpdates = prefs.bidUpdates;
    _offerUpdates = prefs.offerUpdates;
    _lowStockAlerts = prefs.lowStockAlerts;
    _initialised = true;
  }

  void _save() {
    context.read<NotificationCubit>().updateNotificationPreferences(
      orderUpdates: _orderUpdates,
      bidUpdates: _bidUpdates,
      offerUpdates: _offerUpdates,
      lowStockAlerts: _lowStockAlerts,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _itemsForRole(_role);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'notification Preferences',
        showCartIcon: false,
        onCartTap: () {},
        leading: true,
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              if (data is UpdatePreferencesResponse) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Preferences saved'),
                    backgroundColor: AppColors.primery,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                );
              }
              if (data is NotificationPreferencesResponse) {
                setState(() => _initFromPrefs(data.notificationPreferences));
              }
            },
            fail: (msg) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: AppColors.ternary),
            ),
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                children: [

                  SizedBox(height: 12.h),

                  Text(
                    'Choose which notifications you want to receive.',
                    style: AppStyle.body5,
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primery.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(items.length, (i) {
                        final item = items[i];
                        return Column(
                          children: [
                            PreferenceTile(
                              icon: item.icon,
                              iconColor: item.iconColor,
                              title: item.title,
                              subtitle: item.subtitle,
                              value: item.getValue(this),
                              isFirst: i == 0,
                              isLast: i == items.length - 1,
                              onChanged: isLoading
                                  ? null
                                  : (v) =>
                                        setState(() => item.setValue(this, v)),
                            ),
                            if (i < items.length - 1)
                              Divider(
                                height: 1,
                                color: AppColors.lightprimery,
                                indent: 64.w,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primery,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      onPressed: isLoading ? null : _save,
                      child: isLoading
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Save Preferences',
                              style: AppStyle.boldBackground,
                            ),
                    ),
                  ),
                ],
              ),

              // Initial loading overlay
              if (isLoading && !_initialised)
                const ColoredBox(
                  color: Colors.white54,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primery),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
