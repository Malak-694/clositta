// product_list_response_model.dart
import 'product_response_model.dart';

class ProductListResponseModel {
  final List<ProductModelBuyer> products;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ProductListResponseModel({
    required this.products,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ProductListResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductListResponseModel(
      products: (json['products'] as List)
          .map((e) => ProductModelBuyer.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['pagination']['total'] as int,
      page: json['pagination']['page'] as int,
      limit: json['pagination']['limit'] as int,
      totalPages: json['pagination']['totalPages'] as int,
    );
  }

  bool get hasMore => page < totalPages;
}
