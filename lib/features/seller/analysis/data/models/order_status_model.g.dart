// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStatusBreakdownModel _$OrderStatusBreakdownModelFromJson(
  Map<String, dynamic> json,
) => OrderStatusBreakdownModel(
  count: (json['count'] as num).toInt(),
  status: json['status'] as String,
);

Map<String, dynamic> _$OrderStatusBreakdownModelToJson(
  OrderStatusBreakdownModel instance,
) => <String, dynamic>{'count': instance.count, 'status': instance.status};
