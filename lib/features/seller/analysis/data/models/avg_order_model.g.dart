// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avg_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvgOrderValueModel _$AvgOrderValueModelFromJson(Map<String, dynamic> json) =>
    AvgOrderValueModel(
      avgOrderValue: (json['avgOrderValue'] as num).toInt(),
      avgWithShipping: (json['avgWithShipping'] as num).toInt(),
    );

Map<String, dynamic> _$AvgOrderValueModelToJson(AvgOrderValueModel instance) =>
    <String, dynamic>{
      'avgOrderValue': instance.avgOrderValue,
      'avgWithShipping': instance.avgWithShipping,
    };
