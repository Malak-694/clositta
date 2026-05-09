import 'dart:io';

import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/tailor/portfolio/data/models/tailor_portfolio_bundle_model.dart';
import 'package:dio/dio.dart';

import '../../../../../core/models/message_model.dart';

class PortfolioTailorRepo {
  final ApiService apiService;
  PortfolioTailorRepo({required this.apiService});

  Future<ApiResult<TailorPortfolioBundleModel>> viewPortfolioTailor(
    String token,
    String? category,
  ) async {
    try {
      final response = await apiService.viewPortfolioTailor(
        "Bearer $token",
        category,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }

  Future<ApiResult<MessageModel>> addPortfolioItem({
    required String token,
    required String title,
    required String category,
    required String description,
    required String imagePath,
  }) async {
    try {
      final file = File(imagePath);

      if (!await file.exists()) {
        throw Exception("Image file not found");
      }

      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(RegExp(r'[/\\]')).last,
      );

      final response = await apiService.addPortfolioItem(
        "Bearer $token",
        title,
        category,
        description,
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

  Future<ApiResult<MessageModel>> deletePortfolioTailor(
    String token,
    String itemId,
  ) async {
    try {
      final response = await apiService.deletePortfolioTailor(
        "Bearer $token",
        itemId,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }

  Future<ApiResult<MessageModel>> updatePortfolioItem({
    required String token,
    required String itemId,
    required String title,
    required String category,
    required String description,
    String? imagePath,
  }) async {
    try {
      MultipartFile? multipartFile;

      if (imagePath != null) {
        final file = File(imagePath);
        if (!await file.exists()) {
          throw Exception("Image file not found");
        }
        multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split(RegExp(r'[/\\]')).last,
        );
      }

      final response = await apiService.updatePortfolioItem(
        "Bearer $token",
        itemId,
        title,
        category,
        description,
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
