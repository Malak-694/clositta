import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_request_model.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_response_model.dart';

import '../../../../core/models/message_model.dart';
import '../../../../core/networking/api_service.dart';

class MeasurementsRepo {
  final ApiService apiService;
  MeasurementsRepo({required this.apiService});
  Future<ApiResult<MeasurementsResponseModel>> getMeasurements({required String token}) async {
    try {
      final response = await apiService.getMeasurements("Bearer $token");
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
  Future<ApiResult<MeasurementsResponseModel>> updateMeasurements({required String token, required MeasurementsModel body}) async {
    try {
      final response = await apiService.updateMeasurements("Bearer $token", body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
  Future<ApiResult<MessageModel>> deleteMeasurements({required String token}) async {
    try {
      final response = await apiService.deleteMeasurements("Bearer $token");
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(mapErrorToUserMessage(e));
    }
  }
}