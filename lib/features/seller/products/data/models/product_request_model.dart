import 'package:json_annotation/json_annotation.dart';
part 'product_request_model.g.dart';

@JsonSerializable()
class ProductRequestModel {
  final String? id;
  final String name;
  final String description;
  final String price;
  final String stock;
  final String category;
  final String type;
  final String? imageUrl;

  ProductRequestModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.type,
    this.imageUrl,
  });

  factory ProductRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ProductRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductRequestModelToJson(this);
}