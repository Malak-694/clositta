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

import '../../../../../core/widgets/custom_category_selector.dart';

class DetailesScreen extends StatefulWidget {
  final String bidId;
  final String urlImage;
  final String description;
  final String bidStatus; // "open", "updated", "closed"

  const DetailesScreen({
    super.key,
    required this.bidId,
    required this.urlImage,
    required this.description,
    required this.bidStatus,
  });

  @override
  State<DetailesScreen> createState() => _DetailesScreenState();
}
class _DetailesScreenState extends State<DetailesScreen> {
  late bool isBidOpen;

  String _filterType = 'Best 3';
  String _sortType = 'Price';
  final List<String> _filterCategories = ['Best 3', 'All'];
  final List<String> _sortCategories = ['Price', 'Time'];

  @override
  void initState() {
    super.initState();
    isBidOpen = widget.bidStatus == "open" || widget.bidStatus == "updated";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerBiddingCubit>().getBestOffers(widget.bidId);
    });
  }

  void _onFilterChanged(String filter) {
    if (filter == _filterType) return;
    setState(() => _filterType = filter);

    final cubit = context.read<CustomerBiddingCubit>();
    if (filter == 'Best 3') {
      cubit.refreshBestOffers(widget.bidId);
    } else {
      cubit.refreshOffers(widget.bidId);
    }
  }

  List<OfferResponse> _applySort(List<OfferResponse> offers) {
    final result = List<OfferResponse>.from(offers);
    result.sort((a, b) {
      switch (_sortType) {
        case 'Price':
          return (a.price ?? 0).compareTo(b.price ?? 0);
        case 'Time':
          return (a.timeInDays ?? 0).compareTo(b.timeInDays ?? 0);
        default:
          return 0;
      }
    });
    return result;
  }

  void _handleAcceptOffer(BuildContext context, String offerId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Accept Offer", style: AppStyle.boldSecondary),
        content: Text(
          "Are you sure you want to accept this offer? All other offers will be rejected.",
          style: AppStyle.medLight,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: AppColors.light)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<CustomerBiddingCubit>().acceptOffer(
                offerId,
                widget.bidId,
              );
            },
            child: Text("Accept", style: TextStyle(color: AppColors.primery)),
          ),
        ],
      ),
    );
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
        padding: const EdgeInsets.fromLTRB(15, 0, 15,15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tailor bids", style: AppStyle.boldSecondary),
            SizedBox(height: 5.h),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
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
            SizedBox(height: 10.h),

            // ── Status Badge ─────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                //   decoration: BoxDecoration(
                //     color: isBidOpen
                //         ? AppColors.lightprimery
                //         : AppColors.lightternary.withOpacity(0.2),
                //     borderRadius: BorderRadius.circular(20.r),
                //   ),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(
                //         isBidOpen ? Icons.lock_open : Icons.lock,
                //         size: 14.sp,
                //         color: isBidOpen ? AppColors.primery : AppColors.ternary,
                //       ),
                //       SizedBox(width: 4.w),
                //       Text(
                //         isBidOpen ? "Open for offers" : "Closed",
                //         style: TextStyle(
                //           fontSize: 12.sp,
                //           fontWeight: FontWeight.w600,
                //           color: isBidOpen ? AppColors.primery : AppColors.ternary,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Spacer(),
                if (isBidOpen) ...[
                      Text('Show', style: AppStyle.body6),
                      SizedBox(width: 6.w),
                      CustomCategorySelector(
                        categories: _filterCategories,
                        selectedCategory: _filterType,
                        onCategorySelected: _onFilterChanged,
                        selectedColor: AppColors.primery,
                        unselectedColor: AppColors.lightprimery,
                        unselectedTextColor: AppColors.darkprimery,
                      ),
                      Spacer(),
                      Text('Sort by', style: AppStyle.body6),
                      SizedBox(width: 6.w),
                      CustomCategorySelector(
                        categories: _sortCategories,
                        selectedCategory: _sortType,
                        onCategorySelected: (val) =>
                            setState(() => _sortType = val),
                        selectedColor: AppColors.primery,
                        unselectedColor: AppColors.lightprimery,
                        unselectedTextColor: AppColors.darkprimery,
                      ),

                  SizedBox(height: 10.h),
                ],
              ],
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: BlocConsumer<CustomerBiddingCubit, CustomerBiddingState>(
                listener: (context, state) {
                  state.when(
                    initial: () {},
                    loading: () {},
                    fail: (msg) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    success: (data) {
                      if (data is String) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(data),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() => isBidOpen = false);
                        context
                            .read<CustomerBiddingCubit>()
                            .refreshBestOffers(widget.bidId);
                      }
                    },
                  );
                },
                builder: (context, state) {
                  return state.when(
                    initial: () => Center(child: circleIndicator()),
                    loading: () => Center(child: circleIndicator()),
                    fail: (msg) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Failed to retrieve the bids'),
                          const SizedBox(height: 8),
                          CustomElevatedButton(
                            onPressed: () => context
                                .read<CustomerBiddingCubit>()
                                .getBestOffers(widget.bidId),
                            value: 'Retry',
                          ),
                        ],
                      ),
                    ),
                    success: (offers) {
                      if (offers is! List<OfferResponse>) {
                        return const Center(child: Text('Unexpected data'));
                      }

                      final displayedOffers = isBidOpen
                          ? _applySort(offers)
                          : offers
                          .where((o) => o.status == "accepted")
                          .toList();

                      if (displayedOffers.isEmpty) {
                        return Center(
                          child: Text(
                            isBidOpen ? "No offers yet" : "No accepted offer",
                            style: AppStyle.medLight,
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(2.0),
                        itemCount: displayedOffers.length,
                        itemBuilder: (context, index) {
                          final offer = displayedOffers[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: BidItem(
                              offerId: offer.id,
                              tailor: offer.tailor.name,
                              duration: offer.timeInDays,
                              price: offer.price,
                              num_work: 0,
                              comment: offer.message,
                              showSelectButton: isBidOpen,
                              onAccept: () =>
                                  _handleAcceptOffer(context, offer.id),
                            ),
                          );
                        },
                      );
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