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

class DetailesScreenTailor extends StatefulWidget {
  final String urlImage;
  final String describtion;
  final String price;
  final String period;
  final String postId;

  const DetailesScreenTailor({
    super.key,
    required this.urlImage,
    required this.describtion,
    required this.price,
    required this.period,
    required this.postId,
  });

  @override
  State<DetailesScreenTailor> createState() => _DetailesScreenTailorState();
}

class _DetailesScreenTailorState extends State<DetailesScreenTailor> {
  final prefs = getIt<SharedPrefHelper>();
  String? _myTailorId;
  BidModelReponse? _myOffer;

  @override
  void initState() {
    super.initState();
    _loadMyId();
  }

  Future<void> _loadMyId() async {
    final id = await prefs.getSecureData(SharedPrefKey.id);
    if (mounted) setState(() => _myTailorId = id);

  }

  void _updateMyOffer(List<BidModelReponse> offers) {
    final found = offers.where((o) => o.tailor.id == _myTailorId).firstOrNull;
    if (_myOffer?.id != found?.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _myOffer = found);
      });
    }

  }

  void _confirmDeleteOffer(BuildContext context, String offerId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text('Delete Offer', style: AppStyle.body6),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this offer? This action cannot be undone.',
          style: AppStyle.body6.copyWith(fontWeight: FontWeight.normal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: AppStyle.medSecondary),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BiddingTailorCubit>().deleteOffer(
                offerId: offerId,
                postId: widget.postId,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            // ── Post image ───────────────────────────────────
            Container(
              height: 275.h,
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                image: DecorationImage(
                  image: NetworkImage(widget.urlImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Text(widget.describtion, style: AppStyle.medLight),
            SizedBox(height: 15.h),

            // ── Offers list ──────────────────────────────────
            Expanded(
              child: Builder(
                builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (widget.postId.isNotEmpty) {
                      context.read<BiddingTailorCubit>().getOffers(widget.postId);
                    }
                  });

                  return BlocBuilder<BiddingTailorCubit, BiddingTailorState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const CircularProgressIndicator(
                          color: AppColors.secondary,
                          strokeWidth: 5.0,
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.secondary,
                            strokeWidth: 5.0,
                          ),
                        ),
                        fail: (msg) => Center(child: Text(AppStyle.userMessage(msg))),
                        success: (data) {
                          if (data is List<BidModelReponse>) {
                            // ✅ update my offer reference
                            _updateMyOffer(data);

                            if (data.isEmpty) {
                              return const Center(child: Text('No offers yet'));
                            }

                            return ListView.separated(
                              itemCount: data.length,
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (context, index) {
                                final offer = data[index];
                                final isMyOffer =
                                    offer.tailor.id == _myTailorId;

                                return BidItemTailor(
                                  tailorName: offer.tailor.name,
                                  duration: offer.timeInDays,
                                  price: offer.price,
                                  comment: offer.message,
                                  isMyOffer: isMyOffer,
                                  onEdit: ()=> Navigator.pushNamed(
                                    context,
                                    RouteNames.join_bidding,
                                    arguments: {
                                      'urlImage': widget.urlImage,
                                      'price': widget.price,
                                      'period': widget.period,
                                      'title': widget.describtion,
                                      'postId': widget.postId,
                                      'offerId': offer.id,
                                      'initialPrice': offer.price.toString(),
                                      'initialDays': offer.timeInDays.toString(),
                                      'initialMessage': offer.message ?? '',
                                    },
                                  ).then((_) {
                                    // ✅ refreshOffers resets flag then reloads fresh data
                                    if (context.mounted) {
                                      context.read<BiddingTailorCubit>().refreshOffers(widget.postId);
                                    }
                                  }),
                                  onDelete: () =>
                                      _confirmDeleteOffer(context, offer.id),
                                );
                              },
                            );
                          }
                          return const Center(child: Text('Unexpected data'));
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // ── Join / Edit my offer button ──────────────────
            if (_myOffer == null)
              Center(
                child: CustomElevatedButton(
                  value: 'Join Bidding',
                  height: 50.h,
                  width: 350.w,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteNames.join_bidding,
                    arguments: {
                      'urlImage': widget.urlImage,
                      'price': widget.price,
                      'period': widget.period,
                      'title': widget.describtion,
                      'postId': widget.postId,
                    },
                  ),
                ),
              ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'tailor',
        selectedIndex: 0,
      ),
    );
  }
}