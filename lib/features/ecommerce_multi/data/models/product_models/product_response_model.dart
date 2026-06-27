import 'package:chicora/features/ecommerce_multi/data/models/product_models/seller_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../seller/products/data/models/rating_model_response.dart';

part 'product_response_model.g.dart';

@JsonSerializable()
class ProductModelBuyer {
  Map<String, int>? ratingDistribution;
  @JsonKey(name: '_id')
  String? pId;
  SellerModel? seller;
  String? name;
  String? description;
  int? price;
  int? stock;
  String? category;
  String? type;
  String? imageUrl;
  String? imageFileId;
  double? averageRating;
  int? totalRatings;
  List<RatingModel>? ratings;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? iV;
  

  ProductModelBuyer({
    this.ratingDistribution,
    this.pId,
    this.seller,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.category,
    this.type,
    this.imageUrl,
    this.imageFileId,
    this.averageRating,
    this.totalRatings,
    this.ratings,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory ProductModelBuyer.fromJson(Map<String, dynamic> json) =>
      _$ProductModelBuyerFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelBuyerToJson(this);
}

