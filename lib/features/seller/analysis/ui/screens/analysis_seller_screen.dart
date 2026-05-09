import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/constants.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/features/seller/analysis/data/models/analysis_response_model.dart';
import 'package:chicora/features/seller/analysis/logic/cubit/analysis_seller_cubit.dart';
import 'package:chicora/features/seller/analysis/logic/cubit/analysis_seller_state.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_average_order_row.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_city_item.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_customer_item.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_empty_state.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_error_view.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_overview_grid.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_product_item.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_revenue_list.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_section_card.dart';
import 'package:chicora/features/seller/analysis/ui/widgets/analysis_status_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/custom_nav_bar.dart';

class AnalysisSellerScreen extends StatelessWidget {
  const AnalysisSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Seller Analytics',
        showCartIcon: false,
        onCartTap: () {},
      ),
      body: BlocBuilder<AnalysisSellerCubit, AnalysisSellerState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            fail: (message) => AnalysisErrorView(message: message),
            success: (data) {
              if (data is! AnalyticsResponseModel) {
                return const Center(
                  child: Text('Unexpected analysis response format'),
                );
              }
              return _AnalysisContent(analysis: data);
            },
          );
        },
      ),
      bottomNavigationBar: FloatingNavBar(
        userRole: 'seller',
        selectedIndex: 3,
        focused: AppColors.lightternary,
        notSelected: AppColors.primery,
      ),
    );
  }
}

class _AnalysisContent extends StatelessWidget {
  const _AnalysisContent({required this.analysis});

  final AnalyticsResponseModel analysis;

  @override
  Widget build(BuildContext context) {
    final overview = analysis.overview;
    final monthlyRevenue = analysis.revenuePerMonth;
    final weeklyRevenue = analysis.revenuePerWeek;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          AnalysisSectionCard(
            title: 'Overview',
            child: AnalysisOverviewGrid(overview: overview),
          ),
          AnalysisSectionCard(
            title: 'Average Order Value',
            child: AnalysisAverageOrderRow(avgOrderValue: analysis.avgOrderValue),
          ),
          AnalysisSectionCard(
            title: 'Revenue Per Month',
            child: AnalysisRevenueList(
              items: monthlyRevenue,
              getLabel: (item) =>
                  item.monthName ?? 'M${item.month ?? '-'}',
              getSubLabel: (item) => 'Year ${item.year}',
            ),
          ),
          AnalysisSectionCard(
            title: 'Revenue Per Week',
            child: AnalysisRevenueList(
              items: weeklyRevenue,
              getLabel: (item) => item.label ?? 'Week ${item.week ?? '-'}',
              getSubLabel: (item) => 'Orders ${item.orders}',
            ),
          ),
          AnalysisSectionCard(
            title: 'Top Products',
            child: AnalysisEmptyState(
              isEmpty: analysis.topProducts.isEmpty,
              child: Column(
                children: analysis.topProducts
                    .map((item) => AnalysisProductItem(product: item))
                    .toList(),
              ),
            ),
          ),
          AnalysisSectionCard(
            title: 'Bottom Products',
            child: AnalysisEmptyState(
              isEmpty: analysis.bottomProducts.isEmpty,
              child: Column(
                children: analysis.bottomProducts
                    .map((item) => AnalysisProductItem(product: item))
                    .toList(),
              ),
            ),
          ),
          AnalysisSectionCard(
            title: 'Top Cities',
            child: AnalysisEmptyState(
              isEmpty: analysis.topCities.isEmpty,
              child: Column(
                children: analysis.topCities
                    .map((city) => AnalysisCityItem(city: city))
                    .toList(),
              ),
            ),
          ),
          AnalysisSectionCard(
            title: 'Order Status Breakdown',
            child: AnalysisEmptyState(
              isEmpty: analysis.orderStatusBreakdown.isEmpty,
              child: Column(
                children: analysis.orderStatusBreakdown
                    .map((status) => AnalysisStatusItem(status: status))
                    .toList(),
              ),
            ),
          ),
          AnalysisSectionCard(
            title: 'Top Customers',
            child: AnalysisEmptyState(
              isEmpty: analysis.topCustomers.isEmpty,
              child: Column(
                children: analysis.topCustomers
                    .map((item) => AnalysisCustomerItem(customer: item))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      
    );
  }
}
