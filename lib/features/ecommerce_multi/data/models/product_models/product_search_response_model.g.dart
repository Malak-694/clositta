// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSearchResponseModel _$ProductSearchResponseModelFromJson(
  Map<String, dynamic> json,
) => ProductSearchResponseModel(
  image_url: json['image_url'] as String,
  distance: (json['distance'] as num).toDouble(),
  product: json['product'] == null
      ? null
      : ProductModelBuyer.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductSearchResponseModelToJson(
  ProductSearchResponseModel instance,
) => <String, dynamic>{
  'image_url': instance.image_url,
  'distance': instance.distance,
  'product': instance.product,
};
