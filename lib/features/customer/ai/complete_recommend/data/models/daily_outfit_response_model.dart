import 'package:json_annotation/json_annotation.dart';

part 'daily_outfit_response_model.g.dart';

@JsonSerializable()
class DailyOutfitRecommendationResponse {
  final String season;
  final String occasion;
  final Map<String, List<OutfitItemModel>> results;

  DailyOutfitRecommendationResponse({
    required this.season,
    required this.occasion,
    required this.results,
  });

  factory DailyOutfitRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyOutfitRecommendationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DailyOutfitRecommendationResponseToJson(this);
}


extension OutfitResultsX on Map<String, List<OutfitItemModel>> {
  List<Map<String, OutfitItemModel>> buildOutfits() {
    final nonEmpty = Map<String, List<OutfitItemModel>>.fromEntries(
      entries.where((e) => e.value.isNotEmpty),
    );
    if (nonEmpty.isEmpty) return [];

    final count = nonEmpty.values.map((l) => l.length).reduce((a, b) => a < b ? a : b);
    return List.generate(count, (i) {
      final outfit = <String, OutfitItemModel>{};
      nonEmpty.forEach((category, items) => outfit[category] = items[i]);
      return outfit;
    });
  }
}

@JsonSerializable()
class OutfitItemModel {
  final String id;
  @JsonKey(name: 'imagekit_url')
  final String imagekitUrl;
  final double score;
  final ProductInfoModel? product;

  final Map<String, dynamic>? closetItem;

  OutfitItemModel({
    required this.id,
    required this.imagekitUrl,
    required this.score,
    this.product,
    this.closetItem,
  });

  factory OutfitItemModel.fromJson(Map<String, dynamic> json) =>
      _$OutfitItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OutfitItemModelToJson(this);

  String displayLabel(String category) =>
      product?.name ?? category[0].toUpperCase() + category.substring(1);
}

@JsonSerializable()
class ProductInfoModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? description;
  final int? price;
  final int? stock;
  final String? category;
  final String? type;
  final String? imageUrl;
  final ProductInfoSellerModel? seller;
  final double? averageRating;
  final int? totalRatings;

  ProductInfoModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.category,
    this.type,
    this.imageUrl,
    this.seller,
    this.averageRating,
    this.totalRatings,
  });

  factory ProductInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductInfoModelToJson(this);
}

@JsonSerializable()
class ProductInfoSellerModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? email;

  ProductInfoSellerModel({this.id, this.name, this.email});

  factory ProductInfoSellerModel.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoSellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductInfoSellerModelToJson(this);
}