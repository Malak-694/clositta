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
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'confirmpassword': instance.confirmpassword,
      'phone': instance.phone,
      'role': instance.role,
    };

SignUpResponse _$SignUpResponseFromJson(Map<String, dynamic> json) =>
    SignUpResponse(message: json['message'] as String?);

Map<String, dynamic> _$SignUpResponseToJson(SignUpResponse instance) =>
    <String, dynamic>{'message': instance.message};
