// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingResponseModel _$RatingResponseModelFromJson(Map<String, dynamic> json) =>
    RatingResponseModel(
      message: json['message'] as String?,
      averageRating: (json['averageRating'] as num?)?.toInt(),
      totalRatings: (json['totalRatings'] as num?)?.toInt(),
      ratingDistribution: (json['ratingDistribution'] as Map<String, dynamic>?)
          ?.map((k, e) => MapEntry(k, (e as num).toInt())),
    );

Map<String, dynamic> _$RatingResponseModelToJson(
  RatingResponseModel instance,
) => <String, dynamic>{
  'message': instance.message,
  'averageRating': instance.averageRating,
  'totalRatings': instance.totalRatings,
  'ratingDistribution': instance.ratingDistribution,
};
