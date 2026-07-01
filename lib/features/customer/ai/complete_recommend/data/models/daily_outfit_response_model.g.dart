// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_outfit_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyOutfitRecommendationResponse _$DailyOutfitRecommendationResponseFromJson(
  Map<String, dynamic> json,
) => DailyOutfitRecommendationResponse(
  season: json['season'] as String,
  occasion: json['occasion'] as String,
  results: (json['results'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => OutfitItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$DailyOutfitRecommendationResponseToJson(
  DailyOutfitRecommendationResponse instance,
) => <String, dynamic>{
  'season': instance.season,
  'occasion': instance.occasion,
  'results': instance.results,
};

OutfitItemModel _$OutfitItemModelFromJson(Map<String, dynamic> json) =>
    OutfitItemModel(
      id: json['id'] as String,
      imagekitUrl: json['imagekit_url'] as String,
      score: (json['score'] as num).toDouble(),
      product: json['product'] == null
          ? null
          : ProductInfoModel.fromJson(json['product'] as Map<String, dynamic>),
      closetItem: json['closetItem'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$OutfitItemModelToJson(OutfitItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imagekit_url': instance.imagekitUrl,
      'score': instance.score,
      'product': instance.product,
      'closetItem': instance.closetItem,
    };

ProductInfoModel _$ProductInfoModelFromJson(Map<String, dynamic> json) =>
    ProductInfoModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toInt(),
      stock: (json['stock'] as num?)?.toInt(),
      category: json['category'] as String?,
      type: json['type'] as String?,
      imageUrl: json['imageUrl'] as String?,
      seller: json['seller'] == null
          ? null
          : ProductInfoSellerModel.fromJson(
              json['seller'] as Map<String, dynamic>,
            ),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      totalRatings: (json['totalRatings'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductInfoModelToJson(ProductInfoModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'stock': instance.stock,
      'category': instance.category,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'seller': instance.seller,
      'averageRating': instance.averageRating,
      'totalRatings': instance.totalRatings,
    };

ProductInfoSellerModel _$ProductInfoSellerModelFromJson(
  Map<String, dynamic> json,
) => ProductInfoSellerModel(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$ProductInfoSellerModelToJson(
  ProductInfoSellerModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
};
