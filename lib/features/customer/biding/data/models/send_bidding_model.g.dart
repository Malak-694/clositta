// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_bidding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendBiddingModel _$SendBiddingModelFromJson(Map<String, dynamic> json) =>
    SendBiddingModel(
      description: json['requestDescription'] as String,
      price: (json['price'] as num?)?.toDouble(),
      time: json['time'] as String?,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$SendBiddingModelToJson(SendBiddingModel instance) =>
    <String, dynamic>{
      'requestDescription': instance.description,
      'price': instance.price,
      'time': instance.time,
      'imageUrl': instance.imageUrl,
    };
