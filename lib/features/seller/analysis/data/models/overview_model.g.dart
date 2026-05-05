// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverviewModel _$OverviewModelFromJson(Map<String, dynamic> json) =>
    OverviewModel(
      totalRevenue: (json['totalRevenue'] as num).toInt(),
      totalOrders: (json['totalOrders'] as num).toInt(),
      cancelledOrders: (json['cancelledOrders'] as num).toInt(),
      totalItemsSold: (json['totalItemsSold'] as num).toInt(),
      totalShippingCollected: (json['totalShippingCollected'] as num).toInt(),
    );

Map<String, dynamic> _$OverviewModelToJson(OverviewModel instance) =>
    <String, dynamic>{
      'totalRevenue': instance.totalRevenue,
      'totalOrders': instance.totalOrders,
      'cancelledOrders': instance.cancelledOrders,
      'totalItemsSold': instance.totalItemsSold,
      'totalShippingCollected': instance.totalShippingCollected,
    };
