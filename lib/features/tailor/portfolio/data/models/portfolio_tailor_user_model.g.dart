// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_tailor_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioTailorUserModel _$PortfolioTailorUserModelFromJson(
  Map<String, dynamic> json,
) => PortfolioTailorUserModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  imageUrl: json['imageUrl'] as String?,
  location: json['location'] as String?,
  mapsUrl: json['mapsUrl'] as String?,
  averageRating: (json['averageRating'] as num?)?.toDouble(),
  totalRatings: (json['totalRatings'] as num?)?.toInt(),
  ratingDistribution: (json['ratingDistribution'] as Map<String, dynamic>?)
      ?.map((k, e) => MapEntry(k, (e as num).toInt())),
  ratings: (json['ratings'] as List<dynamic>?)
      ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PortfolioTailorUserModelToJson(
  PortfolioTailorUserModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'imageUrl': instance.imageUrl,
  'location': instance.location,
  'mapsUrl': instance.mapsUrl,
  'averageRating': instance.averageRating,
  'totalRatings': instance.totalRatings,
  'ratingDistribution': instance.ratingDistribution,
  'ratings': instance.ratings?.map((e) => e.toJson()).toList(),
};
