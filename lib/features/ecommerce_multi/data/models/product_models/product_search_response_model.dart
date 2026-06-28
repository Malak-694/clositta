import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product_search_response_model.g.dart';

@JsonSerializable()
class ProductSearchResponseModel {
  final String image_url;
  final double distance;
  final ProductModelBuyer? product;

  ProductSearchResponseModel({
    required this.image_url,
    required this.distance,
    this.product,
  });

  factory ProductSearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSearchResponseModelToJson(this);
}
