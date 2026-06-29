import 'package:chicora/core/networking/api_service.dart';

import '../../../../core/models/message_model.dart';
import '../../../../core/networking/api_result.dart';
import '../models/rating_models/rating_request_model.dart';
import '../models/rating_models/rating_response_model.dart';

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
      return  ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
  Future<ApiResult<MessageModel>> deleteRateProduct(
    String token,
    String productId,
  ) async {
    try {
      return ApiResult.success(await apiService.deleteRateProduct( "Bearer $token", productId));
    } catch (e) {
      return  ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
}