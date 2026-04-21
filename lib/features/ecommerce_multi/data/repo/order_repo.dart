import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/cancel_order_request_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_request_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_response_model.dart';

class OrderRepo {
  ApiService apiService;
  OrderRepo({required this.apiService});

  Future<ApiResult<MessageModel>> placeOrder(
    String token,
    OrderRequestModel body,
  ) async {
    try {
      final response = await apiService.placeOrder("Bearer $token", body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<MessageModel>> cancelOrder(
    String token,
    String orderId,
    CancelOrderRequestModel body,
  ) async {
    try {
      final response = await apiService.cancelOrder("Bearer $token", orderId, body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<List<OrderDataModel>>> getMyOrders(String token) async {
    try {
      final response = await apiService.getMyOrders("Bearer $token");
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<OrderDataModel>> getOrderById(
    String token,
    String orderId,
  ) async {
    try {
      final response = await apiService.getOrderById("Bearer $token"  , orderId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
