import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import '../../data/models/bid_model.dart';
import '../widgets/bid_item_tailor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_state.dart';

class DetailesScreenTailor extends StatelessWidget {
  final String urlImage;
  final String describtion;
  final int bids_num = 0;
  final String price;
  final String period;
  final String status = "pending";
  final prefs = getIt<SharedPrefHelper>();
  final String postId;

  DetailesScreenTailor({
    super.key,
    required this.urlImage,
    required this.describtion,
    required this.price,
    required this.period,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Biddings",
        leading: true,
        leadingIcon: Icons.arrow_back,
        showCartIcon: true,
        onCartTap: () =>
            Navigator.pushNamed(context, RouteNames.tailor_cart_screen),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tailor bids", style: AppStyle.boldSecondary),
            SizedBox(height: 5.h),
            Container(
              height: 275.h,
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                image: DecorationImage(
                  image: NetworkImage(urlImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(describtion, style: AppStyle.medLight),
            SizedBox(height: 15.h),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Builder(
                  builder: (context) {
                    // If a postId is provided, trigger loading offers
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (postId.isNotEmpty) {
                        context.read<BiddingTailorCubit>().getOffers(postId);
                      }
                    });

                    return BlocBuilder<BiddingTailorCubit, BiddingTailorState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => const CircularProgressIndicator(
                            color: AppColors.primery,
                            strokeWidth: 5.0,
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primery,
                              strokeWidth: 5.0,
                            ),
                          ),
                          fail: (msg) => Center(child: Text(msg)),
                          success: (data) {
                            if (data is List<BidModelReponse>) {
                              final offers = data;
                              if (offers.isEmpty) {
                                return Center(child: Text('No offers yet'));
                              }
                              return ListView.separated(
                                itemCount: offers.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final offer = offers[index];
                                  return BidItemTailor(
                                    tailorName: offer.tailor.name,
                                    duration: offer.timeInDays,
                                    price: offer.price,
                                    comment: offer.message,
                                  );
                                },
                              );
                            }

                            return Center(child: Text('Unexpected data'));
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Center(
              child: status == "closed"
                  ? Container()
                  : CustomElevatedButton(
                      value: 'join Bidding',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.join_bidding,
                          arguments: {
                            'urlImage': urlImage,
                            'price': price,
                            'period': period,
                            'title': describtion,
                            'postId': postId,
                          },
                        );
                      },
                      height: 39,
                      width: 260,
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FutureBuilder<String?>(
        future: prefs.getSecureData(SharedPrefKey.role),
        builder: (context, snapshot) {
          final role = snapshot.data ?? "Customer";
          return FloatingNavBar(userRole: role, selectedIndex: 0);
        },
      ),
    );
  }
}
