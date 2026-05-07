import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/models/cart_models/cart_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/cart_models/delete_cart_response_model.dart' show DeleteCartResponseModel;

import '../../../../core/models/message_model.dart';
import '../models/cart_models/cart_request_model.dart';

class CartRepo {
  final ApiService apiService;
  CartRepo({required this.apiService});
  Future<ApiResult<CartResponseModel>> getCart(String token) async {
    try {
      final response = await apiService.getCart("Bearer $token");
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
  Future<ApiResult<CartResponseModel>> addToCart(CartRequestModel body, String token) async {
    try {
      final response = await apiService.addToCart("Bearer $token", body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
  Future<ApiResult<CartResponseModel>> updateCart(String productId, CartRequestModel body, String token) async {
    try {
      final response = await apiService.updateCart("Bearer $token", productId, body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
  Future<ApiResult<DeleteCartResponseModel>> removeFromCart(String productId, String token) async {
    try {
      final response = await apiService.removeFromCart("Bearer $token", productId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
  Future<ApiResult<MessageModel>> removeAllCart(String token) async {
    try {
      final response = await apiService.removeAllCart("Bearer $token");
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
}
