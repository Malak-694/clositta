import 'dart:typed_data';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/core/networking/generate_service.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_request_model.dart';
import 'package:dio/dio.dart';

class AiGeneratorRepo {
  final AiGeneratorService _aiGeneratorService = AiGeneratorService();
  final ApiService apiService;

  AiGeneratorRepo({required this.apiService});

  Future<ApiResult<Uint8List>> generateImage({
    required String prompt,
    MultipartFile? referenceImage,
    bool useMyMeasurements = true,
    MeasurementsModel? enteredMeasures,
    required String token,
  }) async {
    try {
      final MeasurementsModel measures;
      if (useMyMeasurements) {
        if (enteredMeasures != null) { //measures from cache
          measures = enteredMeasures;
        } else { 
          final response = await apiService.getMeasurements("Bearer $token");
          if (response.measurements != null) {
            measures = response.measurements!;
          } else {
            return ApiResult.failure("Failed to retrieve measurements.");
          }
        }
      } else {
        measures = enteredMeasures ?? MeasurementsModel();
      }

      final fields = measures.toJson();
      fields['user_prompt'] = prompt;

      final result = await _aiGeneratorService.generateAiLocal(
        fields: fields,
        referenceImage: referenceImage,
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
