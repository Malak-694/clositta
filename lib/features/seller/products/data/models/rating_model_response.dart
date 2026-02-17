import 'package:json_annotation/json_annotation.dart';

part 'rating_model_response.g.dart';

@JsonSerializable()
class RatingModel {
  @JsonKey(name: '_id') // ← Add this annotation
  final String id;
  final String user;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  RatingModel({
    required this.user,
    required this.rating,
    required this.comment,
    required this.id,

    required this.createdAt,
    required this.updatedAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);
}
