// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tailor _$TailorFromJson(Map<String, dynamic> json) => Tailor(
  id: json['_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
);

Map<String, dynamic> _$TailorToJson(Tailor instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
};

OfferResponse _$OfferResponseFromJson(Map<String, dynamic> json) =>
    OfferResponse(
      id: json['_id'] as String,
      bid: json['bid'] as String,
      tailor: Tailor.fromJson(json['tailor'] as Map<String, dynamic>),
      price: (json['price'] as num).toInt(),
      timeInDays: (json['timeInDays'] as num).toInt(),
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: (json['__v'] as num).toInt(),
    );

Map<String, dynamic> _$OfferResponseToJson(OfferResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'bid': instance.bid,
      'tailor': instance.tailor,
      'price': instance.price,
      'timeInDays': instance.timeInDays,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.version,
    };
