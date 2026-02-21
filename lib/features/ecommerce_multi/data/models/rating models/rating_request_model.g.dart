// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingRequestModel _$RatingRequestModelFromJson(Map<String, dynamic> json) =>
    RatingRequestModel(
      (json['rating'] as num?)?.toInt(),
      json['comment'] as String?,
    );

Map<String, dynamic> _$RatingRequestModelToJson(RatingRequestModel instance) =>
    <String, dynamic>{'rating': instance.rating, 'comment': instance.comment};
