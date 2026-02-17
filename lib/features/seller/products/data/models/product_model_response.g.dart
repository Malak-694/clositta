// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  ratingDistribution: Map<String, int>.from(json['ratingDistribution'] as Map),
  id: json['_id'] as String,
  seller: json['seller'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  stock: (json['stock'] as num).toInt(),
  category: json['category'] as String,
  type: json['type'] as String,
  imageUrl: json['imageUrl'] as String,
  imageFileId: json['imageFileId'] as String,
  averageRating: (json['averageRating'] as num).toDouble(),
  totalRatings: (json['totalRatings'] as num).toInt(),
  ratings: (json['ratings'] as List<dynamic>)
      .map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  v: (json['__v'] as num).toInt(),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'ratingDistribution': instance.ratingDistribution,
      '_id': instance.id,
      'seller': instance.seller,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'stock': instance.stock,
      'category': instance.category,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'imageFileId': instance.imageFileId,
      'averageRating': instance.averageRating,
      'totalRatings': instance.totalRatings,
      'ratings': instance.ratings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.v,
    };
