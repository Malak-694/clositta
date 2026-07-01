import 'package:chicora/core/networking/api_service.dart';
import '../models/daily_outfit_request_model.dart';
import '../models/daily_outfit_response_model.dart';

class OutfitRecommendationRepo {
  final ApiService apiService;
  OutfitRecommendationRepo(this.apiService);

  Future<DailyOutfitRecommendationResponse> getDailyOutfitRecommendation({
    required String token,
    required DailyOutfitRequestModel body,
  }) {
    return apiService.getDailyOutfitRecommendation(token, body);
  }
}