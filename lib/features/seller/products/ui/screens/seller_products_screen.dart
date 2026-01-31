import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

class SellerProductsScreen extends StatelessWidget {
  final prefs = getIt<SharedPrefHelper>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: "My Products"),
        body: Container(child: Text("ereereer")),
      ),
    );
  }
}
