// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsResponseModel _$AnalyticsResponseModelFromJson(
  Map<String, dynamic> json,
) => AnalyticsResponseModel(
  overview: OverviewModel.fromJson(json['overview'] as Map<String, dynamic>),
  revenuePerMonth: (json['revenuePerMonth'] as List<dynamic>)
      .map((e) => RevenuePeriodModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  revenuePerWeek: (json['revenuePerWeek'] as List<dynamic>)
      .map((e) => RevenuePeriodModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  topProducts: (json['topProducts'] as List<dynamic>)
      .map((e) => ProductStatsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  bottomProducts: (json['bottomProducts'] as List<dynamic>)
      .map((e) => ProductStatsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  topCities: (json['topCities'] as List<dynamic>)
      .map((e) => CityStatsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  orderStatusBreakdown: (json['orderStatusBreakdown'] as List<dynamic>)
      .map((e) => OrderStatusBreakdownModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  avgOrderValue: AvgOrderValueModel.fromJson(
    json['avgOrderValue'] as Map<String, dynamic>,
  ),
  topCustomers: (json['topCustomers'] as List<dynamic>)
      .map((e) => TopCustomerModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AnalyticsResponseModelToJson(
  AnalyticsResponseModel instance,
) => <String, dynamic>{
  'overview': instance.overview,
  'revenuePerMonth': instance.revenuePerMonth,
  'revenuePerWeek': instance.revenuePerWeek,
  'topProducts': instance.topProducts,
  'bottomProducts': instance.bottomProducts,
  'topCities': instance.topCities,
  'orderStatusBreakdown': instance.orderStatusBreakdown,
  'avgOrderValue': instance.avgOrderValue,
  'topCustomers': instance.topCustomers,
};
