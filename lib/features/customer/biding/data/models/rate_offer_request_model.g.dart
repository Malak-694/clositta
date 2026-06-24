// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_offer_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateOfferRequestModel _$RateOfferRequestModelFromJson(
  Map<String, dynamic> json,
) => RateOfferRequestModel(
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$RateOfferRequestModelToJson(
  RateOfferRequestModel instance,
) => <String, dynamic>{'rating': instance.rating, 'comment': instance.comment};
