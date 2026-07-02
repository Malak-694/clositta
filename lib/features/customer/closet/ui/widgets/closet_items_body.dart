import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/constants.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/pinterest_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/style.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/pinterest_grid_config.dart';
import '../../../../../core/widgets/custom_category_selector.dart';
import '../../../../ecommerce_multi/ui/widgets/filter_side_bar_widget.dart';
import '../../data/models/closet_item_response_model.dart';
import '../../logic/cubit/closet_cubit.dart';
import '../../logic/cubit/closet_state.dart';

class ClosetItemsScreenBody extends StatefulWidget {
  const ClosetItemsScreenBody({super.key});

  @override
  State<ClosetItemsScreenBody> createState() => _ClosetItemsScreenBodyState();
}

class _ClosetItemsScreenBodyState extends State<ClosetItemsScreenBody> {
  final TextEditingController searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    "top",
    "bottom",
    "jacket",
    "scarf",
    "dress",
    "shoes",
    "accessories",
  ];
  String _selectedCategory = 'All';
  String? _selectedSeason;
  String? _selectedOccasion;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'All';
    _selectedSeason = null;
    _selectedOccasion = null;
    // Load closet items on init
    context.read<ClosetCubit>().viewClosetItems(category: null);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(kHorizontalPadding),
      child: Column(
        children: [
          CustomCategorySelector(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
              context.read<ClosetCubit>().filterByCategory(category);
            },
            selectedColor: AppColors.darkprimery,
            unselectedColor: AppColors.primery,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: _openFilterSidebar,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primery.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: AppColors.primery,
                          size: 20.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text('Filter & Sort', style: AppStyle.smallBlack),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),
              CustomElevatedButton(
                value: 'Add',
                onPressed: () {
                  Navigator.pushNamed(context, "upload_closet_item");
                },
                height: 35,
                width: 80,
                style: AppStyle.medBackground.copyWith(fontSize: 15.sp),
              ),
            ],
          ),

          SizedBox(height: 20.h),
          Expanded(
            child: BlocBuilder<ClosetCubit, ClosetState>(
              builder: (context, state) {
                return state.when(
                  initial: () => Center(
                    child: Text(
                      'No items',
                      style: AppStyle.medBlack,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (data) {
                    if (data is List<ClosetItemResponseModel>) {
                      if (data.isEmpty) {
                        return Center(
                          child: Text(
                            'No closet items found',
                            style: AppStyle.medBlack,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return PinterestGrid<ClosetItemResponseModel>(
                        items: data,
                        onTap: (item) {},
                        configBuilder: (item) => PinterestCardConfig(
                          imageUrl: item.imageUrl,
                          name: item.name,
                          showCart: false,
                          showRating: false,
                          showPrice: false,
                          showEdit: true,
                          showDelete: true,
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.update_closet_item,
                              arguments: item,
                            ).then((_) {
                              context.read<ClosetCubit>().viewClosetItems();
                            });
                          },
                          onDelete: () =>
                              _showDeleteConfirmation(context, item), // ✅ new
                          onTap: () {},
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        'No closet items found',
                        style: AppStyle.medBlack,
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  fail: (error) => Center(
                    child: Text(
                      'Error: please try again later',
                      style: AppStyle.medBlack,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ClosetItemResponseModel item,
  ) {
    showDialog(
      context: context,
      builder: (contextDialog) => AlertDialog(
        content: Text(
          'Are you sure you want to delete ${item.name}?',
          style: AppStyle.medBlack.copyWith(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextDialog),
            child: Text(
              'Cancel',
              style: AppStyle.medPrimery.copyWith(fontSize: 12.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(contextDialog);
              if (item.id != null) {
                context.read<ClosetCubit>().deleteClosetItem(itemId: item.id!);
              }
            },
            child: Text(
              'Delete',
              style: AppStyle.medTernary.copyWith(fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFilterSidebar() async {
    final result = await showFilterSidebar(
      context,
      initialPriceSort: PriceSortOrder.none,
      initialGender: '',
      initialSeason: _selectedSeason,
      initialOccasion: _selectedOccasion,
      usePrice: false,
      useGender: false,
    );
    if (result == null) return;
    setState(() {
      _selectedSeason = result.season;
      _selectedOccasion = result.occasion;
    });
    final cubit = context.read<ClosetCubit>();
    cubit.filterBySeason(_selectedSeason ?? 'All');
    cubit.filterByOccasion(_selectedOccasion ?? 'All');
  }
}
