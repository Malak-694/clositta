import 'dart:io';

import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/mock/mock_products.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';

/// Mock product search repository — simulates text and image search endpoints
/// without calling [ApiService].
class ProductSearchRepo {
  static const List<String> _categories = [
    'Tops',
    'Bottoms',
    'Dresses',
    'Shoes',
    'Outwear',
    'Accessories',
    'Kids',
    'Others',
  ];

  Future<void> _simulateDelay() =>
      Future<void>.delayed(const Duration(milliseconds: 400));

  /// Simulates GET /api/products/search?query=
  Future<ApiResult<List<ProductModelBuyer>>> searchByText({
    required String query,
  }) async {
    try {
      await _simulateDelay();
      final trimmed = query.trim();
      if (trimmed.isEmpty) {
        return const ApiResult.failure('Please enter a search term.');
      }

      final lower = trimmed.toLowerCase();
      final results = mockProducts.where((product) {
        final name = product.name?.toLowerCase() ?? '';
        final description = product.description?.toLowerCase() ?? '';
        final category = product.category?.toLowerCase() ?? '';
        return name.contains(lower) ||
            description.contains(lower) ||
            category.contains(lower);
      }).toList();

      return ApiResult.success(results);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  /// Simulates POST /api/products/search/image (multipart)
  Future<ApiResult<List<ProductModelBuyer>>> searchByImage({
    required String imagePath,
  }) async {
    try {
      await _simulateDelay();
      final file = File(imagePath);
      if (!file.existsSync()) {
        return const ApiResult.failure('Selected image file was not found.');
      }

      final fileName = imagePath.split(Platform.pathSeparator).last;
      final categoryIndex = fileName.hashCode.abs() % _categories.length;
      final targetCategory = _categories[categoryIndex];

      final results = mockProducts
          .where((product) => product.category == targetCategory)
          .toList();

      if (results.isEmpty) {
        return ApiResult.success(mockProducts.take(4).toList());
      }

      return ApiResult.success(results);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
