// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityStatsModel _$CityStatsModelFromJson(Map<String, dynamic> json) =>
    CityStatsModel(
      orders: (json['orders'] as num).toInt(),
      revenue: (json['revenue'] as num).toInt(),
      city: json['city'] as String,
    );

Map<String, dynamic> _$CityStatsModelToJson(CityStatsModel instance) =>
    <String, dynamic>{
      'orders': instance.orders,
      'revenue': instance.revenue,
      'city': instance.city,
    };
