import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import 'models/analysis_response_model.dart';

class AnalysisSellerRepo {
    final ApiService apiService;
  AnalysisSellerRepo({required this.apiService});
  Future<ApiResult<AnalyticsResponseModel>> getSellerAnalysis(String token) async {
    try {
      final response = await apiService.getSellerAnalysis("Bearer $token");
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}