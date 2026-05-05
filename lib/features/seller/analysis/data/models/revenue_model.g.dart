// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevenuePeriodModel _$RevenuePeriodModelFromJson(Map<String, dynamic> json) =>
    RevenuePeriodModel(
      revenue: (json['revenue'] as num).toInt(),
      orders: (json['orders'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num?)?.toInt(),
      monthName: json['monthName'] as String?,
      week: (json['week'] as num?)?.toInt(),
      label: json['label'] as String?,
    );

Map<String, dynamic> _$RevenuePeriodModelToJson(RevenuePeriodModel instance) =>
    <String, dynamic>{
      'revenue': instance.revenue,
      'orders': instance.orders,
      'year': instance.year,
      'month': instance.month,
      'monthName': instance.monthName,
      'week': instance.week,
      'label': instance.label,
    };
