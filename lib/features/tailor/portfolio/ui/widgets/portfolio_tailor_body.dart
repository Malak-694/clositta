import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/constants.dart';
import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/pinterest_grid.dart';
import 'package:chicora/features/auth/ui/widgets/drop_down_type.dart';
import 'package:chicora/features/tailor/portfolio/logic/cubit/portfolio_tailor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/style.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/widgets/pinterest_grid_config.dart';
import '../../data/models/portfolio_tailor_response_model.dart';
import '../../logic/cubit/portfolio_tailor_state.dart';

class PortfolioTailorBody extends StatefulWidget {
  const PortfolioTailorBody({super.key});

  @override
  State<PortfolioTailorBody> createState() => _PortfolioTailorBodyState();
}

class _PortfolioTailorBodyState extends State<PortfolioTailorBody> {
  final TextEditingController searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Tops',
    'Bottoms',
    'Shoes',
    'Accessories',
  ];

  @override
  void initState() {
    super.initState();
    // Load portfolio items on init
    context.read<PortfolioTailorCubit>().viewPortfolioTailor(null);
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDropdownList(
                  fillColor: AppColors.lightsecondary,
                  width: 90.w,
                  height: 37.h,
                  vPadding: 3.h,
                  style: AppStyle.medSecondary.copyWith(color: AppColors.darksecondary),
                  items: _categories,
                  value: 'All',
                  hintText: 'Category',
                  onChanged: (category) {
                    context.read<PortfolioTailorCubit>().filterByCategory(
                      category ?? 'All',
                    );
                  },
                ),
              ),
              const Spacer(),
              SizedBox(width: 10.w),
              CustomElevatedButton(
                background: AppColors.secondary,
                value: 'Add',
                onPressed: () {
                  Navigator.pushNamed(context, "added_work_screen");
                },
                height: 35,
                width: 80,
                style: AppStyle.medBackground.copyWith(fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: BlocBuilder<PortfolioTailorCubit, PortfolioTailorState>(
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
                    if (data is List<PortfolioTailorResponseModel>) {
                      if (data.isEmpty) {
                        return Center(
                          child: Text(
                            'No Portfoliio items found',
                            style: AppStyle.medBlack,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return PinterestGrid<PortfolioTailorResponseModel>(
                        items: data,
                        onTap: (item) {},
                        configBuilder: (item) => PinterestCardConfig(
                          imageUrl: item.imageUrl,
                          name: item.title,
                          showCart: false,
                          showRating: false,
                          showPrice: false,
                          showEdit: true,
                          onEdit: () {
                            final cubit =
                                context.read<PortfolioTailorCubit>();
                            Navigator.pushNamed(
                              context,
                              RouteNames.update_work_screen,
                              arguments: item,
                            ).then((_) {
                              cubit.viewPortfolioTailor(null);
                            });
                          },
                          onTap: () {
                            _showDeleteConfirmation(context, item);
                          },
                        ),
                        mainColor: AppColors.secondary,
                        darkColor: AppColors.darksecondary,
                      );
                    }
                    return Center(
                      child: Text(
                        'No portfolio items found',
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
    PortfolioTailorResponseModel item,
  ) {
    showDialog(
      context: context,
      builder: (contextDialog) => AlertDialog(
        content: Text(
          'Are you sure you want to delete ${item.title}?',
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
                context.read<PortfolioTailorCubit>().deletePortfolioTailor(
                  item.id!,
                );
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
