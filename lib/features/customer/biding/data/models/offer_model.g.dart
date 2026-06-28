// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tailor _$TailorFromJson(Map<String, dynamic> json) => Tailor(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$TailorToJson(Tailor instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
};

BidNested _$BidNestedFromJson(Map<String, dynamic> json) => BidNested(
  id: json['_id'] as String?,
  customer: json['customer'] as String?,
  requestDescription: json['requestDescription'] as String?,
  imageUrl: json['imageUrl'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  time: json['time'] as String?,
  status: json['status'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BidNestedToJson(BidNested instance) => <String, dynamic>{
  '_id': instance.id,
  'customer': instance.customer,
  'requestDescription': instance.requestDescription,
  'imageUrl': instance.imageUrl,
  'price': instance.price,
  'time': instance.time,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

OfferRating _$OfferRatingFromJson(Map<String, dynamic> json) => OfferRating(
  user: json['user'] as String?,
  rating: (json['rating'] as num?)?.toInt(),
  comment: json['comment'] as String?,
  id: json['_id'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OfferRatingToJson(OfferRating instance) =>
    <String, dynamic>{
      'user': instance.user,
      'rating': instance.rating,
      'comment': instance.comment,
      '_id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

OfferResponse _$OfferResponseFromJson(Map<String, dynamic> json) =>
    OfferResponse(
      id: json['_id'] as String?,
      bid: json['bid'] == null
          ? null
          : BidNested.fromJson(json['bid'] as Map<String, dynamic>),
      tailor: json['tailor'] == null
          ? null
          : Tailor.fromJson(json['tailor'] as Map<String, dynamic>),
      price: (json['price'] as num?)?.toInt(),
      timeInDays: (json['timeInDays'] as num?)?.toInt(),
      message: json['message'] as String?,
      status: json['status'] as String?,
      workStatus: json['workStatus'] as String?,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      ratings: (json['ratings'] as List<dynamic>?)
          ?.map((e) => OfferRating.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      version: (json['__v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OfferResponseToJson(OfferResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'bid': instance.bid,
      'tailor': instance.tailor,
      'price': instance.price,
      'timeInDays': instance.timeInDays,
      'message': instance.message,
      'status': instance.status,
      'workStatus': instance.workStatus,
      'deadline': instance.deadline?.toIso8601String(),
      'ratings': instance.ratings,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      '__v': instance.version,
    };
