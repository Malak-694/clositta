// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_tailor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostTailor _$PostTailorFromJson(Map<String, dynamic> json) => PostTailor(
  sId: json['sId'] as String?,
  customer: json['customer'] == null
      ? null
      : CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
  requestDescription: json['requestDescription'] as String?,
  imageUrl: json['imageUrl'] as String?,
  price: (json['price'] as num?)?.toInt(),
  time: json['time'] as String?,
  status: json['status'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  iV: (json['iV'] as num?)?.toInt(),
);

Map<String, dynamic> _$PostTailorToJson(PostTailor instance) =>
    <String, dynamic>{
      'sId': instance.sId,
      'customer': instance.customer,
      'requestDescription': instance.requestDescription,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'time': instance.time,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
    };

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    CustomerModel(
      sId: json['sId'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$CustomerModelToJson(CustomerModel instance) =>
    <String, dynamic>{
      'sId': instance.sId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
    };
