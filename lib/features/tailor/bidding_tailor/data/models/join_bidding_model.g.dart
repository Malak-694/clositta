// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_bidding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinBiddingRequest _$JoinBiddingRequestFromJson(Map<String, dynamic> json) =>
    JoinBiddingRequest(
      price: (json['price'] as num?)?.toInt(),
      timeInDays: (json['timeInDays'] as num?)?.toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$JoinBiddingRequestToJson(JoinBiddingRequest instance) =>
    <String, dynamic>{
      'price': instance.price,
      'timeInDays': instance.timeInDays,
      'message': instance.message,
    };

JoinBiddingResponse _$JoinBiddingResponseFromJson(Map<String, dynamic> json) =>
    JoinBiddingResponse(message: json['message'] as String?);

Map<String, dynamic> _$JoinBiddingResponseToJson(
  JoinBiddingResponse instance,
) => <String, dynamic>{'message': instance.message};
