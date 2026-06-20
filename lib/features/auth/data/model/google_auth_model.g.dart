// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAuthRequestModel _$GoogleAuthRequestModelFromJson(
  Map<String, dynamic> json,
) => GoogleAuthRequestModel(
  idToken: json['idToken'] as String,
  role: json['role'] as String?,
);

Map<String, dynamic> _$GoogleAuthRequestModelToJson(
  GoogleAuthRequestModel instance,
) => <String, dynamic>{'idToken': instance.idToken, 'role': instance.role};

GoogleAuthResponseModel _$GoogleAuthResponseModelFromJson(
  Map<String, dynamic> json,
) => GoogleAuthResponseModel(
  token: json['token'] as String,
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$GoogleAuthResponseModelToJson(
  GoogleAuthResponseModel instance,
) => <String, dynamic>{
  'token': instance.token,
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'imageUrl': instance.imageUrl,
};
