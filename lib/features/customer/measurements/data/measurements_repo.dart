import 'package:chicora/core/networking/api_result.dart';

import 'model/measurements_model.dart';

/// Mock measurements repository — simulates /api/measurements endpoints
/// without calling [ApiService].
class MeasurementsRepo {
  static final Map<String, MeasurementsModel> _store = {};
  static int _idCounter = 1;

  Future<void> _simulateDelay() =>
      Future<void>.delayed(const Duration(milliseconds: 400));

  Future<ApiResult<GetMeasurementsResponse>> getMeasurements({
    required String userId,
  }) async {
    try {
      await _simulateDelay();
      final data = _store[userId];
      if (data == null) {
        return const ApiResult.failure(
          'No measurements found. Please create them first.',
        );
      }
      return ApiResult.success(GetMeasurementsResponse(measurements: data));
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<SaveMeasurementsResponse>> createMeasurements({
    required String userId,
    required MeasurementsRequest body,
  }) async {
    try {
      await _simulateDelay();
      if (_store.containsKey(userId)) {
        return const ApiResult.failure(
          'Measurements already exist. Use update instead.',
        );
      }

      final measurements = MeasurementsModel(
        id: 'meas_${_idCounter++}',
        userId: userId,
        chest: body.chest ?? 0,
        waist: body.waist ?? 0,
        hips: body.hips ?? 0,
        shoulders: body.shoulders ?? 0,
        armLength: body.armLength ?? 0,
        inseam: body.inseam ?? 0,
        height: body.height ?? 0,
        unit: body.unit ?? 'cm',
      );
      _store[userId] = measurements;
//TODO : call real api to save measurements
      return ApiResult.success(
        SaveMeasurementsResponse(
          message: 'Measurements saved',
          measurements: measurements,
        ),
      );
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<SaveMeasurementsResponse>> updateMeasurements({
    required String userId,
    required MeasurementsRequest body,
  }) async {
    try {
      await _simulateDelay();
      final existing = _store[userId];
      if (existing == null) {
        return const ApiResult.failure(
          'No measurements found. Please create them first.',
        );
      }

      final updated = existing.copyWith(
        chest: body.chest,
        waist: body.waist,
        hips: body.hips,
        shoulders: body.shoulders,
        armLength: body.armLength,
        inseam: body.inseam,
        height: body.height,
        unit: body.unit,
      );
      _store[userId] = updated;

      return ApiResult.success(
        SaveMeasurementsResponse(
          message: 'Measurements updated',
          measurements: updated,
        ),
      );
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<DeleteMeasurementsResponse>> deleteMeasurements({
    required String userId,
  }) async {
    try {
      await _simulateDelay();
      if (!_store.containsKey(userId)) {
        return const ApiResult.failure(
          'No measurements found. Please create them first.',
        );
      }
      _store.remove(userId);
      return const ApiResult.success(
        DeleteMeasurementsResponse(message: 'Measurements deleted'),
      );
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
