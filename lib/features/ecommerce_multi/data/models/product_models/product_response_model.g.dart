// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModelBuyer _$ProductModelBuyerFromJson(Map<String, dynamic> json) =>
    ProductModelBuyer(
        ratingDistribution:
            (json['ratingDistribution'] as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, (e as num).toInt()),
            ),
        pId: json['_id'] as String?,
        seller: json['seller'] == null
            ? null
            : SellerModel.fromJson(json['seller'] as Map<String, dynamic>),
        name: json['name'] as String?,
        description: json['description'] as String?,
        price: (json['price'] as num?)?.toInt(),
        stock: (json['stock'] as num?)?.toInt(),
        category: json['category'] as String?,
        type: json['type'] as String?,
        imageUrl: json['imageUrl'] as String?,
        imageFileId: json['imageFileId'] as String?,
        averageRating: (json['averageRating'] as num?)?.toDouble(),
        totalRatings: (json['totalRatings'] as num?)?.toInt(),
        ratings: (json['ratings'] as List<dynamic>?)
            ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        iV: (json['__v'] as num?)?.toInt(),
      )
      ..gender = json['gender'] as String?
      ..season = json['season'] as String?
      ..occasion = json['occasion'] as String?
      ..color = json['color'] as String?;

Map<String, dynamic> _$ProductModelBuyerToJson(ProductModelBuyer instance) =>
    <String, dynamic>{
      'ratingDistribution': instance.ratingDistribution,
      '_id': instance.pId,
      'seller': instance.seller,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'stock': instance.stock,
      'category': instance.category,
      'type': instance.type,
      'gender': instance.gender,
      'season': instance.season,
      'occasion': instance.occasion,
      'color': instance.color,
      'imageUrl': instance.imageUrl,
      'imageFileId': instance.imageFileId,
      'averageRating': instance.averageRating,
      'totalRatings': instance.totalRatings,
      'ratings': instance.ratings,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '__v': instance.iV,
    };
