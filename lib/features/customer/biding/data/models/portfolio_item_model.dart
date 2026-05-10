// lib/features/portfolio/data/models/portfolio_item_model.dart

import 'package:json_annotation/json_annotation.dart';
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
  final TailorInfo tailor;
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

@JsonSerializable()
class TailorInfo {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String email;

  const TailorInfo({
    required this.id,
    required this.name,
    required this.email,
  });

  factory TailorInfo.fromJson(Map<String, dynamic> json) =>
      _$TailorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TailorInfoToJson(this);
}