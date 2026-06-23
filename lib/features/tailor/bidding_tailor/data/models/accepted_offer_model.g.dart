// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accepted_offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptedOfferCustomer _$AcceptedOfferCustomerFromJson(
  Map<String, dynamic> json,
) => AcceptedOfferCustomer(
  id: json['_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
);

Map<String, dynamic> _$AcceptedOfferCustomerToJson(
  AcceptedOfferCustomer instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
};

AcceptedOfferBid _$AcceptedOfferBidFromJson(Map<String, dynamic> json) =>
    AcceptedOfferBid(
      id: json['_id'] as String,
      requestDescription: json['requestDescription'] as String,
      customer: AcceptedOfferCustomer.fromJson(
        json['customer'] as Map<String, dynamic>,
      ),
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AcceptedOfferBidToJson(AcceptedOfferBid instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'requestDescription': instance.requestDescription,
      'customer': instance.customer,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
    };

AcceptedOfferResponse _$AcceptedOfferResponseFromJson(
  Map<String, dynamic> json,
) => AcceptedOfferResponse(
  id: json['_id'] as String,
  bid: AcceptedOfferBid.fromJson(json['bid'] as Map<String, dynamic>),
  price: (json['price'] as num).toInt(),
  timeInDays: (json['timeInDays'] as num).toInt(),
  message: json['message'] as String,
  status: json['status'] as String? ?? 'accepted',
  workStatus: json['workStatus'] as String?,
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  daysRemaining: (json['daysRemaining'] as num?)?.toInt(),
  isOverdue: json['isOverdue'] as bool?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  version: (json['__v'] as num).toInt(),
);

Map<String, dynamic> _$AcceptedOfferResponseToJson(
  AcceptedOfferResponse instance,
) => <String, dynamic>{
  '_id': instance.id,
  'bid': instance.bid,
  'price': instance.price,
  'timeInDays': instance.timeInDays,
  'message': instance.message,
  'status': instance.status,
  'workStatus': instance.workStatus,
  'deadline': instance.deadline?.toIso8601String(),
  'daysRemaining': instance.daysRemaining,
  'isOverdue': instance.isOverdue,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  '__v': instance.version,
};
