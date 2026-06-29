import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/features/notifications/data/models/notification_pref_config.dart';
import 'package:chicora/features/notifications/data/models/notification_preferences.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_elevated_button.dart';
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

class _PreferencesBody extends StatefulWidget {
  const _PreferencesBody();

  @override
  State<_PreferencesBody> createState() => _PreferencesBodyState();
}

class _PreferencesBodyState extends State<_PreferencesBody> {
  Map<PrefKey, bool> _prefs = {
    PrefKey.orderUpdates:   true,
    PrefKey.bidUpdates:     true,
    PrefKey.offerUpdates:   true,
    PrefKey.lowStockAlerts: true,
  };
  bool _initialised = false;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final role = await getIt<SharedPrefHelper>().getSecureData(SharedPrefKey.role);
    if (!mounted) return;
    setState(() => _role = role);
  }

  void _initFromPrefs(NotificationPreferences prefs) {
    if (_initialised) return;
    _prefs = {
      PrefKey.orderUpdates:   prefs.orderUpdates,
      PrefKey.bidUpdates:     prefs.bidUpdates,
      PrefKey.offerUpdates:   prefs.offerUpdates,
      PrefKey.lowStockAlerts: prefs.lowStockAlerts,
    };
    _initialised = true;
  }

  void _toggle(PrefKey key, bool value) =>
      setState(() => _prefs[key] = value);

  void _save() {
    context.read<NotificationCubit>().updateNotificationPreferences(
      orderUpdates:   _prefs[PrefKey.orderUpdates]!,
      bidUpdates:     _prefs[PrefKey.bidUpdates]!,
      offerUpdates:   _prefs[PrefKey.offerUpdates]!,
      lowStockAlerts: _prefs[PrefKey.lowStockAlerts]!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = keysForRole(_role);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Notification Preferences',
        showCartIcon: false,
        onCartTap: () {},
        leading: true,
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              if (data is UpdatePreferencesResponse) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Preferences saved'),
                  backgroundColor: AppColors.primery,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                ));
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
          final isLoading =
          state.maybeWhen(loading: () => true, orElse: () => false);

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
                      children: List.generate(keys.length, (i) {
                        final key = keys[i];
                        final m   = prefMeta[key]!;
                        return Column(
                          children: [
                            PreferenceTile(
                              icon: m.icon,
                              iconColor: m.iconColor,
                              title: m.title,
                              subtitle: m.subtitleFor(_role),
                              value: _prefs[key]!,
                              isFirst: i == 0,
                              isLast: i == keys.length - 1,
                              onChanged: isLoading
                                  ? null
                                  : (v) => _toggle(key, v),
                            ),
                            if (i < keys.length - 1)
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

                  CustomElevatedButton(
                    height: 53,
                    value: "Save Preferences",
                    onPressed: () => isLoading ? null : _save,
                  ),
                ],
              ),

              if (isLoading && !_initialised)
                const ColoredBox(
                  color: Colors.white54,
                  child: Center(
                      child: CircularProgressIndicator(color: AppColors.primery)),
                ),
            ],
          );
        },
      ),
    );
  }
}