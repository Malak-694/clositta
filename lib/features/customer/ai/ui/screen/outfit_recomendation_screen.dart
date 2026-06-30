import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitRecomendationScreen extends StatelessWidget {
  const OutfitRecomendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> occasion = [
      'Casual',
      "Formal",
      "Sportswear",
      "Party",
      "Outdoor",
    ];
    final List<String> season = ['Spring', "Summer", "Autumn", "Winter"];

    return Scaffold(
      appBar: CustomAppBar(
        title: "Outfit Recomendation",
        showCartIcon: false,
        onCartTap: () {},
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Container(
                height: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.light, width: 0.7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      CustomDropdownList(
                        height: 47.h,
                        value: 'Casual',
                        items: occasion,
                        hintText: 'ex,Casual',
                        onChanged: (_) {},
                        label: 'occasion',
                      ),
                      SizedBox(height: 15.h),
                      CustomDropdownList(
                        height: 47.h,

                        value: 'Winter',
                        items: season,
                        hintText: 'ex,Winter',
                        onChanged: (_) {},
                        label: 'season',
                      ),
                      Spacer(),
                      CustomElevatedButton(
                        value: 'Get Recomedation',
                        onPressed: () {},
                        height: 50.h,
                        style: AppStyle.button.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
