import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/ecommerce_multi/data/models/rating%20models/rating_request_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/rating%20models/rating_response_model.dart';

import '../../../../core/models/message_model.dart';
import '../../../../core/networking/api_result.dart';

class RateProductsRepo {
  final ApiService apiService;
  RateProductsRepo({required this.apiService});
  Future<ApiResult<RatingResponseModel>> rateProduct(
    String token,
    String productId,
    RatingRequestModel body,
  ) async {
    try {
      return ApiResult.success(await apiService.rateProduct( "Bearer $token", productId, body));
    } catch (e) {
      return  ApiResult.failure(e.toString());
    }
  }
  Future<ApiResult<MessageModel>> deleteRateProduct(
    String token,
    String productId,
  ) async {
    try {
      return ApiResult.success(await apiService.deleteRateProduct( "Bearer $token", productId));
    } catch (e) {
      return  ApiResult.failure(e.toString());
    }
  }
}