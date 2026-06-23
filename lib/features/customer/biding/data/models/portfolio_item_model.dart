// lib/features/portfolio/data/models/portfolio_item_model.dart

import 'package:chicora/features/seller/products/data/models/rating_model_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../tailor/portfolio/data/models/portfolio_tailor_user_model.dart';
part 'portfolio_item_model.g.dart';

@JsonSerializable()
class PortfolioItem {
  @JsonKey(name: '_id')
  final String id;

  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final String imageFileId;
  final PortfolioTailorUserModel tailor;
  final String createdAt;
  final String updatedAt;

  const PortfolioItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.imageFileId,
    required this.tailor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) =>
      _$PortfolioItemFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioItemToJson(this);

  Map<String, dynamic> toGridItem() => {
    'image': imageUrl,
    'name': title,
    'price': 0,
    'rating': 0,
    'description': description,
    'category': category,
  };
}
//----maybe we need to remove
@JsonSerializable()
class TailorInfo {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String email;
  final String? phone;
  final String? location;
  final String? imageUrl;
  final String? mapsUrl;
  final double? averageRating;
  final int? totalRatings;
  final Map<String, int>? ratingDistribution;
  final List<RatingModel>? ratings;
  const TailorInfo({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.imageUrl,
    this.location,
    this.mapsUrl,
    this.averageRating,
    this.totalRatings,
    this.ratingDistribution,
    this.ratings,
  });

  factory TailorInfo.fromJson(Map<String, dynamic> json) =>
      _$TailorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TailorInfoToJson(this);
}
