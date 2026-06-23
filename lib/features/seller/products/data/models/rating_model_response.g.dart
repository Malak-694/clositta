// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) => RatingModel(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  id: json['_id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RatingModelToJson(RatingModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

User _$UserFromJson(Map<String, dynamic> json) =>
    User(id: json['_id'] as String, name: json['name'] as String);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
};
