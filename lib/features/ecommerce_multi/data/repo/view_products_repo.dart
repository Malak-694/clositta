import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';

class ViewProductsRepo {
  final ApiService apiService;
  ViewProductsRepo({required this.apiService});

  Future<ApiResult<List<ProductModelBuyer>>> getProductsBuyer({
    required String token,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    String? sellerId,
    String? search,
    String? type,
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
type  : type
        );

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
}
