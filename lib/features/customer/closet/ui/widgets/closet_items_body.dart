import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/constants.dart';
import 'package:chicora/core/widgets/custom_category_selector.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/custom_search_bar.dart';
import 'package:chicora/core/widgets/pinterest_grid.dart';
import 'package:chicora/features/auth/ui/widgets/drop_down_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/style.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/pinterest_grid_config.dart';
import '../../data/models/closet_item_response_model.dart';
import '../../logic/cubit/closet_cubit.dart';
import '../../logic/cubit/closet_state.dart';

class ClosetItemsScreenBody extends StatefulWidget {
  ClosetItemsScreenBody({super.key});

  @override
  State<ClosetItemsScreenBody> createState() => _ClosetItemsScreenBodyState();
}

class _ClosetItemsScreenBodyState extends State<ClosetItemsScreenBody> {
  final TextEditingController searchController = TextEditingController();
  final Color _primaryColor = AppColors.primery;
  final Color _darkColor = AppColors.darkprimery;
  final List<String> _categories = [
    'All',
    'Tops',
    'Bottoms',
    'Shoes',
    'Accessories',
  ];
  final List<String> _seasons = ['All', 'Winter', 'Spring', 'Summer', 'Fall'];
  late String _selectedCategory;
  late String _selectedSeason;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'All';
    _selectedSeason = 'All';
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
          Row(
            children: [
              CustomDropdown(
                vPadding: 3.h,
                style: AppStyle.medPrimery.copyWith(fontSize: 12.sp),
                items: _categories,
                value: 'All',
                hintText: 'Category',
                width: 130.w,
                onChanged: (category) {
                  setState(() {
                    _selectedCategory = category!;
                  });
                  context.read<ClosetCubit>().filterByCategory(category!);
                },
              ),
              const Spacer(),
              CustomDropdown(
                vPadding: 3.h,
                style: AppStyle.medPrimery.copyWith(fontSize: 12.sp),
                items: _seasons,
                value: 'All',
                hintText: 'Season',
                width: 130.w,
                onChanged: (season) {
                  setState(() {
                    _selectedSeason = season!;
                  });
                  context.read<ClosetCubit>().filterBySeason(season!);
                },
              ),
              const Spacer(),
              SizedBox(width: 10.w),
              CustomElevatedButton(
                value: 'Add',
                onPressed: () {
                  Navigator.pushNamed(context, "upload_closet_item");
                },
                height: 35,
                width: 80,
                style: AppStyle.medBackground.copyWith(fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(height: 20.h),

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
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.update_closet_item,
                              arguments: item,
                            ).then((_) {
                              context.read<ClosetCubit>().viewClosetItems();
                            });
                          },
                          onTap: () {
                            _showDeleteConfirmation(context, item);
                          },
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
}
