// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      confirmpassword: json['confirmpassword'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      location: json['location'] as String?,
      mapsUrl: json['mapsUrl'] as String?,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'confirmpassword': instance.confirmpassword,
      'phone': instance.phone,
      'role': instance.role,
      'location': instance.location,
      'mapsUrl': instance.mapsUrl,
    };

SignUpReturnedUser _$SignUpReturnedUserFromJson(Map<String, dynamic> json) =>
    SignUpReturnedUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      imageUrl: json['imageUrl'] as String?,
      location: json['location'] as String?,
      mapsUrl: json['mapsUrl'] as String?,
    );

Map<String, dynamic> _$SignUpReturnedUserToJson(SignUpReturnedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'imageUrl': instance.imageUrl,
      'location': instance.location,
      'mapsUrl': instance.mapsUrl,
    };

SignUpResponse _$SignUpResponseFromJson(Map<String, dynamic> json) =>
    SignUpResponse(
      message: json['message'] as String?,
      user: json['user'] == null
          ? null
          : SignUpReturnedUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignUpResponseToJson(SignUpResponse instance) =>
    <String, dynamic>{'message': instance.message, 'user': instance.user};
