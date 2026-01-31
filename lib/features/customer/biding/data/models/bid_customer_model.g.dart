// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  id: json['_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
};

BidResponse _$BidResponseFromJson(Map<String, dynamic> json) => BidResponse(
  id: json['_id'] as String,
  customerId: json['customer'] as String,
  requestDescription: json['requestDescription'] as String,
  imageUrl: json['imageUrl'] as String,
  price: (json['price'] as num?)?.toDouble(),
  time: json['time'] as String?,
  status: json['status'] as String? ?? 'open',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  version: (json['__v'] as num).toInt(),
);

Map<String, dynamic> _$BidResponseToJson(BidResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'customer': instance.customerId,
      'requestDescription': instance.requestDescription,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'time': instance.time,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.version,
    };
