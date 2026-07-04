// product_page_data.dart
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';


class ProductPageData {
  final List<ProductModelBuyer> products;
  final bool hasMore;
  final bool isLoadingMore;

  const ProductPageData({
    required this.products,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  ProductPageData copyWith({
    List<ProductModelBuyer>? products,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProductPageData(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}