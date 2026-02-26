import 'dart:io';

import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:dio/dio.dart';
import '../../../../../core/networking/api_result.dart';
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


  Future<ApiResult<MessageModel>> addProduct({
    required String token,
    required String name,
    required String description,
    required String price,
    required String stock,
    required String category,
    required String type,
    required String imagePath,
  }) async {
    try {
      final file = File(imagePath);

      if (!await file.exists()) {
        throw Exception("Image file not found");
      }

      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );

      final response = await apiService.addProduct(
        "Bearer $token",
        name,
        description,
        price,
        stock,
        category,
        type,
        multipartFile,
      );

      return ApiResult.success(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResult.failure(
            "Server error: ${e.response?.statusCode} - ${e.response?.data}");
      }
      return ApiResult.failure("Network error: ${e.message}");
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<MessageModel>> updateProduct({
    required String token,
    required String productId,
    required String name,
    required String description,
    required String price,
    required String stock,
    required String category,
    required String type,
    String? imagePath,
  }) async {
    try {
      MultipartFile? multipartFile;

      if (imagePath != null) {
        final file = File(imagePath);
        if (!await file.exists()) throw Exception("Image file not found");
        multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
      }

      final response = await apiService.updateProduct(
        "Bearer $token",
        productId,
        name,
        description,
        price,
        stock,
        category,
        type,
        multipartFile,
      );

      return ApiResult.success(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResult.failure(
            "Server error: ${e.response?.statusCode} - ${e.response?.data}");
      }
      return ApiResult.failure("Network error: ${e.message}");
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

}
