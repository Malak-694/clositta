import 'dart:typed_data';
import 'package:chicora/core/networking/dio_factory.dart';
import 'package:dio/dio.dart';

class AiGeneratorService {
  final Dio _dio = DioFactory.getDio();

  Future<Uint8List> generateAiLocal({
    required Map<String, dynamic> fields,
    MultipartFile? referenceImage,
  }) async {
    final formData = FormData.fromMap({
      ...fields,
      if (referenceImage != null) 'reference_image': referenceImage,
    });

    final response = await _dio.post(
      "https://web-production-9babf.up.railway.app/ai_generator/generate",
      data: formData,
      options: Options(responseType: ResponseType.bytes),
    );

    return Uint8List.fromList(response.data);
  }
}