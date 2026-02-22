import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/features/tailor/portfolio/data/models/portfolio_tailor_response_model.dart';

import '../../../../../core/models/message_model.dart';

class PortfolioTailorRepo {
  final ApiService apiService;
  PortfolioTailorRepo({required this.apiService});
  Future<ApiResult<List<PortfolioTailorResponseModel>>> viewPortfolioTailor(
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
      return ApiResult.failure(e.toString());
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
      return ApiResult.failure(e.toString());
    }
  }
}
