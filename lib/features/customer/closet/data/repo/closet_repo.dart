import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';

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
      return ApiResult.failure(e.toString());
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
      return ApiResult.failure(e.toString());
    }
  }
}
