import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/products_list_response_model.dart';

class ViewProductsRepo {
  final ApiService apiService;
  ViewProductsRepo({required this.apiService});

  Future<ApiResult<ProductListResponseModel>> getProductsBuyer({
    required String token,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    String? sellerId,
    String? search,
    String? type,
    String? season,
    String? occasion,
    String? gender,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await apiService.getProductsBuyer(
        token: "Bearer $token",
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        inStock: inStock,
        sellerId: sellerId,
        search: search,
        type: type,
        season: season,
        occasion: occasion,
        gender: gender,
        page: page,
        limit: limit,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
}