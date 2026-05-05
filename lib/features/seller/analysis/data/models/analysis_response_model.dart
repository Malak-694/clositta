import 'package:chicora/features/seller/analysis/data/models/avg_order_model.dart';
import 'package:chicora/features/seller/analysis/data/models/city_stats_model.dart';
import 'package:chicora/features/seller/analysis/data/models/order_status_model.dart' show OrderStatusBreakdownModel;
import 'package:chicora/features/seller/analysis/data/models/overview_model.dart' show OverviewModel;
import 'package:chicora/features/seller/analysis/data/models/product_stats_model.dart';
import 'package:chicora/features/seller/analysis/data/models/revenue_model.dart';
import 'package:chicora/features/seller/analysis/data/models/top_customer_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'analysis_response_model.g.dart';

@JsonSerializable()
class AnalyticsResponseModel {
  final OverviewModel overview;
  final List<RevenuePeriodModel> revenuePerMonth;
  final List<RevenuePeriodModel> revenuePerWeek;
  final List<ProductStatsModel> topProducts;
  final List<ProductStatsModel> bottomProducts;
  final List<CityStatsModel> topCities;
  final List<OrderStatusBreakdownModel> orderStatusBreakdown;
  final AvgOrderValueModel avgOrderValue;
  final List<TopCustomerModel> topCustomers;

  AnalyticsResponseModel({
    required this.overview,
    required this.revenuePerMonth,
    required this.revenuePerWeek,
    required this.topProducts,
    required this.bottomProducts,
    required this.topCities,
    required this.orderStatusBreakdown,
    required this.avgOrderValue,
    required this.topCustomers,
  });

  factory AnalyticsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsResponseModelToJson(this);
}