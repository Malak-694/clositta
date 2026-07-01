import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:chicora/core/networking/api_service.dart';
import '../models/complete_outfit_request_model.dart';
import '../models/complete_outfit_response_model.dart';

class CompleteOutfitRepo {
  final ApiService apiService;
  CompleteOutfitRepo(this.apiService);

  Future<CompleteOutfitResponseModel> getCompleteOutfit({
    required String imagePath,
    required CompleteOutfitRequestModel body,
  }) async {
    final image = await MultipartFile.fromFile(
      imagePath,
      filename: imagePath.split('/').last,
    );
    return apiService.getCompleteOutfitRecommendation(
      image,
      jsonEncode(body.toJson()),
    );
  }
}