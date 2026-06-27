import 'dart:io';

import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/mock/mock_products.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';
import 'package:dio/dio.dart' show MultipartFile;

import '../../../../core/networking/api_service.dart';
import '../models/product_models/product_search_response_model.dart';

/// Mock product search repository — simulates text and image search endpoints
/// without calling [ApiService].
class ProductSearchRepo {
  final ApiService apiService;

  ProductSearchRepo({required this.apiService});

  /// Simulates GET /api/products/search?query=
  Future<ApiResult<List<ProductSearchResponseModel>>> searchByText({
    required Map<String, dynamic> body,
  }) async {
    try {
      final results = await apiService.searchByText(body);
      return ApiResult.success(results);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  /// Simulates POST /api/products/search/image (multipart)
  Future<ApiResult<List<ProductSearchResponseModel>>> searchByImage({
    required String imagePath,
  }) async {
    try {
      MultipartFile? image;

      final file = File(imagePath);
      if (!await file.exists()) throw Exception("Image file not found");
      image = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(RegExp(r'[/\\]')).last,
      );

      final results = await apiService.searchByImage(image);
      return ApiResult.success(results);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
