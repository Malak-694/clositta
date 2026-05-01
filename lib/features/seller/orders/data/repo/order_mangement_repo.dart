import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/seller/orders/data/models/order_seller_response_model.dart';
import 'package:chicora/features/seller/orders/data/models/order_update_seller_request_model.dart';
import 'package:chicora/features/seller/orders/data/models/order_update_seller_response.dart';

class OrderMangementRepo {
  final ApiService apiService;

  OrderMangementRepo({required this.apiService});

  Future<ApiResult<List<OrderSellerResponseModel>>> getAllOrdersSeller(
    String token, {
    String? status,
  }) async {
    try {
      final response = await apiService.getAllOrdersSeller(
        "Bearer $token",
        status: status,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<OrderUpdateSellerResponseModel>> updateOrderStatusSeller(
    String token,
    String orderId,
    OrderUpdateSellerRequestModel body,
  ) async {
    try {
      final response = await apiService.updateOrderStatusSeller(
        "Bearer $token",
        orderId,
        body,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}

