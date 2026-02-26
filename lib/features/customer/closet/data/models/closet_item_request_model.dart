
import 'package:json_annotation/json_annotation.dart';


part 'closet_item_request_model.g.dart';

@JsonSerializable()
class ClosetItemRequestModel {
  final String? image;
  final String name;
  final String category;
  final String season;
  final String color;

  ClosetItemRequestModel({
    this.image,
    required this.name,
    required this.category,
    required this.season,
    required this.color,
  });


  factory ClosetItemRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ClosetItemRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClosetItemRequestModelToJson(this);
}