import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/circle_indicator.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/features/customer/biding/data/models/offer_model.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_state.dart';
import 'package:chicora/features/customer/biding/ui/widgets/bid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailesScreen extends StatefulWidget {
  final String bidId; // ADD THIS
  final String urlImage;
  final String description;

  const DetailesScreen({
    super.key,
    required this.bidId,
    required this.urlImage,
    required this.description,
  });

  @override
  State<DetailesScreen> createState() => _DetailesScreenState();
}

class _DetailesScreenState extends State<DetailesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch offers when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerBiddingCubit>().getBestOffers(widget.bidId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Back to Posts", style: AppStyle.boldTernary),
        leadingWidth: 20.w,
        iconTheme: IconThemeData(color: AppColors.ternary),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tailor bids", style: AppStyle.boldSecondary),
            SizedBox(height: 5.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // ← background for empty space
                borderRadius: BorderRadius.circular(20.sp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.sp),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    widget.urlImage,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),

            Text(widget.description, style: AppStyle.medLight),
            SizedBox(height: 15.h),
            Expanded(
              child: BlocBuilder<CustomerBiddingCubit, CustomerBiddingState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => Center(child: circleIndicator()),
                    loading: () => Center(child: circleIndicator()),
                    fail: (msg) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('failed to retrive the bids'),
                          const SizedBox(height: 8),
                          CustomElevatedButton(
                            onPressed: () => context
                                .read<CustomerBiddingCubit>()
                                .getMyBids(),
                            value: 'Retry',
                          ),
                        ],
                      ),
                    ),
                    success: (offers) {
                      if (offers is List<OfferResponse>) {
                        if (offers.isEmpty) {
                          return Center(
                            child: Text(
                              "No offers yet",
                              style: AppStyle.medLight,
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.all(2.0),
                          itemCount: offers.length,
                          itemBuilder: (context, index) {
                            final offer = offers[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: BidItem(
                                tailor:
                                    offer.tailor.name, // Use real tailor name
                                duration: offer.timeInDays,
                                price: offer.price,
                                num_work:
                                    0, // You might need to add this field to OfferResponse
                                comment: offer.message,
                                // Optional: pass offer ID
                              ),
                            );
                          },
                        );
                      }
                      return Center(child: Text('Unexpected data'));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
