// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileResponse _$UpdateProfileResponseFromJson(
  Map<String, dynamic> json,
) => UpdateProfileResponse(
  message: json['message'] as String,
  user: UpdatedUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateProfileResponseToJson(
  UpdateProfileResponse instance,
) => <String, dynamic>{'message': instance.message, 'user': instance.user};

UpdatedUser _$UpdatedUserFromJson(Map<String, dynamic> json) => UpdatedUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  role: json['role'] as String,
  imageUrl: json['imageUrl'] as String?,
  location: json['location'] as String?,
  mapsUrl: json['mapsUrl'] as String?,
);

Map<String, dynamic> _$UpdatedUserToJson(UpdatedUser instance) =>
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
