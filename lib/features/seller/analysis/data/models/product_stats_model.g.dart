// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductStatsModel _$ProductStatsModelFromJson(Map<String, dynamic> json) =>
    ProductStatsModel(
      productName: json['productName'] as String,
      productImage: json['productImage'] as String,
      totalQuantitySold: (json['totalQuantitySold'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toInt(),
      timesOrdered: (json['timesOrdered'] as num).toInt(),
      productId: json['productId'] as String,
    );

Map<String, dynamic> _$ProductStatsModelToJson(ProductStatsModel instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'productImage': instance.productImage,
      'totalQuantitySold': instance.totalQuantitySold,
      'totalRevenue': instance.totalRevenue,
      'timesOrdered': instance.timesOrdered,
      'productId': instance.productId,
    };
