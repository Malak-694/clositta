import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import '../../../../../core/networking/api_service.dart';

class SellerProductRepo {
  final ApiService apiService;
  SellerProductRepo({required this.apiService});
  Future<List<ProductModel>> getProductsSeller(String token) async {
    final response = await apiService.getProductsSeller("Bearer $token");
    return response;
  }

  Future<MessageModel> deleteProduct(
    String token,
    String productId,
  ) async {
    final response = await apiService.deleteProduct("Bearer $token", productId);
    return response;
  }
}
