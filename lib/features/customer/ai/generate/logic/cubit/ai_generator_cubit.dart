import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/customer/ai/generate/data/generate_repo.dart';
import 'package:chicora/features/customer/ai/generate/logic/cubit/ai_generator_state.dart';
import 'package:chicora/features/customer/closet/data/repo/closet_repo.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_request_model.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/helper/shared_key.dart';
import '../../../../../../core/helper/shared_pref_helper.dart';

class AiGeneratorCubit extends Cubit<AiGeneratorState> {
  final AiGeneratorRepo _repo;
  final ClosetRepo _closetRepo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  AiGeneratorCubit({
    required AiGeneratorRepo repo,
    required ClosetRepo closetRepo,
  }) : _closetRepo = closetRepo,
       _repo = repo,
       super(const AiGeneratorState.initial());
  Future<String?> _getUserToken() async {
    return _prefs.getSecureData(SharedPrefKey.token);
  }

  MeasurementsModel? _getMeasurementsFromCache() {
    final unit = _prefs.getData(SharedPrefKey.unit);

    // If there is no cached data, return null.
    if (unit == null || unit.isEmpty) {
      return null;
    }

    return MeasurementsModel(
      unit: unit,
      weight: _prefs.getData(SharedPrefKey.weight),
      chest: _prefs.getData(SharedPrefKey.chest),
      waist: _prefs.getData(SharedPrefKey.waist),
      hips: _prefs.getData(SharedPrefKey.hips),
      shoulders: _prefs.getData(SharedPrefKey.shoulders),
      armLength: _prefs.getData(SharedPrefKey.armLength),
      inseam: _prefs.getData(SharedPrefKey.inseam),
      height: _prefs.getData(SharedPrefKey.height),
    );
  }

  Future<void> generateImage(
    String prompt,
    bool useMyMeasurements,
    MeasurementsModel? others, {
    Object? referenceImage,
  }) async {
    emit(const AiGeneratorState.loading());
    final token = await _getUserToken();
    if (token == null || token.isEmpty) {
      emit(const AiGeneratorState.fail('User not found. Please login again.'));
      return;
    }

    MultipartFile? multipartFile;
    if (referenceImage is File) {
      multipartFile = await MultipartFile.fromFile(referenceImage.path);
    } else if (referenceImage is Uint8List) {
      multipartFile = MultipartFile.fromBytes(
        referenceImage,
        filename: 'reference.jpg',
      );
    }
    final role = await _prefs.getSecureData(SharedPrefKey.role);

    bool isTailor = role != "customer";

    MeasurementsModel? enteredMeasures = others;

    if (!isTailor && useMyMeasurements) {
      enteredMeasures = _getMeasurementsFromCache();
    }

    final result = await _repo.generateImage(
      prompt: prompt,
      useMyMeasurements: useMyMeasurements,
      enteredMeasures: enteredMeasures,
      referenceImage: multipartFile,
      isTailor: isTailor,
      token: token,
    );
    result.when(
      success: (data) {
        emit(AiGeneratorState.success(data));
      },
      failure: (message) {
        emit(
          AiGeneratorState.fail(
            'the ai is not available now , try again later',
          ),
        );
      },
    );
  }

  Future<void> addClosetItem({
    required String name,
    required String category,
    required String season,
    required String color,
    required String imagePath,
  }) async {
    try {
      final token = await _getUserToken();
      if (token == null || token.isEmpty) {
        emit(const AiGeneratorState.fail("Authentication token not found"));
        return;
      }

      if (imagePath.isEmpty) {
        emit(const AiGeneratorState.fail("Please select an image"));
        return;
      }

      final response = await _closetRepo.addClosetItem(
        token: token,
        name: name,
        category: category,
        season: season,
        color: color,
        imagePath: imagePath,
      );

      response.when(
        success: (MessageModel data) {
          // emit(AiGeneratorState.success(data));
        },
        failure: (String error) {
          emit(AiGeneratorState.fail(error));
        },
      );
    } catch (e) {
      emit(
        AiGeneratorState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to add item. Please try again.",
        ),
      );
    }
  }
}
