import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/style.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_dropdown_list.dart';
import '../../../../../core/widgets/custom_nav_bar.dart';
import '../../data/models/accepted_offer_model.dart';

class ActiveOrderScreen extends StatelessWidget {
  const ActiveOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BiddingTailorCubit>()..getMyAcceptedOffers(),
      child: const _ActiveOrderView(),
    );
  }
}

class _ActiveOrderView extends StatefulWidget {
  const _ActiveOrderView();

  @override
  State<_ActiveOrderView> createState() => _ActiveOrderViewState();
}

class _ActiveOrderViewState extends State<_ActiveOrderView> {
  List<AcceptedOfferResponse> _orders = [];
  bool _isLoadingDialogOpen = false;
  String _selectedFilter = 'all'; // 👈 filter state
  List<String> states = ['all', 'accepted', 'in_progress', 'completed'] ;
  String _statusLabel(String? s) {
    switch (s) {
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Accepted';
    }
  }

  List<AcceptedOfferResponse> get _filteredOrders {
    if (_selectedFilter == 'all') return _orders;
    return _orders.where((o) {
      final status = o.workStatus ?? 'accepted';
      return status == _selectedFilter;
    }).toList();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24.sp),
            SizedBox(width: 8.w),
            Text('Error', style: AppStyle.medBlack),
          ],
        ),
        content: Text(message, style: AppStyle.medLight),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: AppStyle.boldPrimery),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Active Orders',
        showCartIcon: true,
        onCartTap: () {},
      ),
      backgroundColor: AppColors.background,
      body: BlocListener<BiddingTailorCubit, BiddingTailorState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {
              if (!_isLoadingDialogOpen) {
                _isLoadingDialogOpen = true;
                _showLoadingDialog();
              }
            },
            fail: (err) {
              if (_isLoadingDialogOpen) {
                _isLoadingDialogOpen = false;
                Navigator.pop(context);
              }
              _showErrorDialog(err);
            },
            success: (data) {
              if (_isLoadingDialogOpen) {
                _isLoadingDialogOpen = false;
                Navigator.pop(context);
              }
              final orders = data as List<AcceptedOfferResponse>;
              setState(() => _orders = orders);
            },
          );
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.w),
              child:
              Align(
                alignment: Alignment.centerRight,
                child: DropdownButton<String>(
                  isDense: true,
                  value: _selectedFilter,
                  underline: const SizedBox.shrink(),
                  icon: Icon(Icons.sort, color: AppColors.primery, size: 22.sp),
                  style: AppStyle.medBlack.copyWith(fontSize: 14.sp),
                  items: states.map((f) => DropdownMenuItem(
                    value: f,
                    child: Text(_statusLabel(f == 'all' ? null : f), style: AppStyle.smallBlack),
                  ))
                      .toList(),
                  selectedItemBuilder: (context) {
                    return states.map((f) {
                      if (f == 'all') return const SizedBox.shrink();
                      return Row(children: [
                        Text(_statusLabel(f), style: AppStyle.smallBlack),
                        SizedBox(width: 4.w),
                      ]);
                    }).toList();
                  },
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedFilter = val);
                  },
                ),
              ),
            ),
            SizedBox(height: 8.h),

            Expanded(
              child: _orders.isEmpty
                  ? const Center(child: Text("No active orders"))
                  : _filteredOrders.isEmpty
                  ? Center(
                child: Text(
                  'No orders with status "${_statusLabel(_selectedFilter)}"',
                  style: AppStyle.medLight,
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                itemCount: _filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = _filteredOrders[index];
                  final dropdownItems = [
                    'accepted',
                    'in_progress',
                    'completed'
                  ];

                  return Card(
                    color: AppColors.background,
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                order.bid.requestDescription,
                                style: AppStyle.medBlack,
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(25),
                                  color: AppColors.lightprimery,
                                ),
                                child: Text(
                                  _statusLabel(order.workStatus),
                                  style: TextStyle(fontSize: 11.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'for ${order.bid.customer.name}',
                            style: AppStyle.medPrimery
                                .copyWith(fontSize: 17.sp),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text('Deadline',
                                      style: AppStyle.medPrimery
                                          .copyWith(fontSize: 17.sp)),
                                  Text(
                                    order.isOverdue == true
                                        ? 'Overdue!'
                                        : '${order.daysRemaining ?? order.timeInDays} days',
                                    style: AppStyle.body5,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text('Payment',
                                      style: AppStyle.medPrimery
                                          .copyWith(fontSize: 17.sp)),
                                  Text(
                                    '\$${order.price}',
                                    style: AppStyle.body5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: CustomDropdownList(
                                  label: "Status",
                                  value:
                                  order.workStatus ?? 'accepted',
                                  items: dropdownItems,
                                  hintText: "",
                                  onChanged: (newStatus) {
                                    context
                                        .read<BiddingTailorCubit>()
                                        .updateWorkStatus(
                                        order.id, newStatus!);
                                  },
                                ),
                              ),
                              SizedBox(width: 8.w),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.chat_screen,
                                    arguments: {
                                      'receiverId': order.bid.customer.id,
                                      'receiverName': order.bid.customer.name,
                                    },
                                  );
                                },
                                borderRadius:
                                BorderRadius.circular(12.r),
                                child: Container(
                                  padding: EdgeInsets.all(13.w),
                                  width: 70.w ,
                                  decoration: BoxDecoration(
                                    color: AppColors.primery,
                                    borderRadius:
                                    BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: AppColors.background,
                                    size: 22.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'tailor',
        selectedIndex: 1,
      ),
    );
  }
}