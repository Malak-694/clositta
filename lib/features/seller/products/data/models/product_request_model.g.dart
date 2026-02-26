// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductRequestModel _$ProductRequestModelFromJson(Map<String, dynamic> json) =>
    ProductRequestModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      stock: json['stock'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$ProductRequestModelToJson(
  ProductRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'stock': instance.stock,
  'category': instance.category,
  'type': instance.type,
  'imageUrl': instance.imageUrl,
};
