import 'dart:io';

import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:dio/dio.dart';

import '../../../../../core/networking/api_service.dart';
import '../models/closet_item_response_model.dart';

class ClosetRepo {
  final ApiService apiService;
  ClosetRepo({required this.apiService});
  Future<ApiResult<List<ClosetItemResponseModel>>> viewClosetItems({
    required String token,
    String? category,
    String? season,
  }) async {
    try {
      final response = await apiService.viewClosetItems(
        "Bearer $token",
        category,
        season,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }

  Future<ApiResult<MessageModel>> deleteClosetItem({
    required String token,
    required String itemId,
  }) async {
    try {
      final response = await apiService.deleteClosetItem(
       "Bearer $token",
        itemId,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }

  Future<ApiResult<MessageModel>> addClosetItem({
    required String token,
    required String name,
    required String category,
    required String season,
    required String color ,
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

      final response = await apiService.addClosetItem(
        "Bearer $token",
        name,
        category,
        season,
        color,
        multipartFile,
      );

      return ApiResult.success(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResult.failure("Server error: ${e.response?.statusCode} - ${e.response?.data}");
      }
      return ApiResult.failure("Network error: ${e.message}");
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }

  Future<ApiResult<MessageModel>> updateClosetItem({
    required String token,
    required String itemId,
    required String name,
    required String category,
    required String season,
    required String color,
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

      final response = await apiService.updateClosetItem(
        "Bearer $token",
        itemId,
        name,
        category,
        season,
        color,
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
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }

}
