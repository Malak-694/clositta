import 'package:chicora/features/seller/products/data/models/rating_model_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product_model_response.g.dart';

@JsonSerializable()
class ProductModel {
  final Map<String, int> ratingDistribution;

  @JsonKey(name: '_id')
  final String id;
  final String seller; // sellerId
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String type;
  final String imageUrl;
  final String imageFileId;
  final double averageRating;
  final int totalRatings;

  final List<RatingModel> ratings;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(name: '__v')
  final int v;

  ProductModel({
    required this.ratingDistribution,

    required this.id,
    required this.seller,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.type,
    required this.imageUrl,
    required this.imageFileId,
    required this.averageRating,
    required this.totalRatings,
    required this.ratings,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
