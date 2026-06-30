import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/customer/measurements/data/measurements_repo.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_request_model.dart';
import 'package:chicora/features/customer/measurements/logic/cubit/measurements_state.dart';

class MeasurementsCubit extends Cubit<MeasurementsState> {
  final MeasurementsRepo _repo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  MeasurementsModel? currentMeasurements;
  bool? hasExistingMeasurements;

  MeasurementsCubit({required MeasurementsRepo repo})
    : _repo = repo,
      super(const MeasurementsState.initial());

  Future<String?> _getUserToken() async {
    return _prefs.getSecureData(SharedPrefKey.token);
  }

  _saveMeasurements(MeasurementsModel measurements) async {
    _prefs.setData(SharedPrefKey.unit, measurements.unit ?? '');
    _prefs.setData(SharedPrefKey.weight, measurements.weight ?? 0);
    _prefs.setData(SharedPrefKey.chest, measurements.chest ?? 0);
    _prefs.setData(SharedPrefKey.waist, measurements.waist ?? 0);
    _prefs.setData(SharedPrefKey.hips, measurements.hips ?? 0);
    _prefs.setData(SharedPrefKey.shoulders, measurements.shoulders ?? 0);
    _prefs.setData(SharedPrefKey.armLength, measurements.armLength ?? 0);
    _prefs.setData(SharedPrefKey.inseam, measurements.inseam ?? 0);
    _prefs.setData(SharedPrefKey.height, measurements.height ?? 0);
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

  Future<void> _clearMeasurementsCache() async {
    await _prefs.remove(SharedPrefKey.unit);
    await _prefs.remove(SharedPrefKey.weight);
    await _prefs.remove(SharedPrefKey.chest);
    await _prefs.remove(SharedPrefKey.waist);
    await _prefs.remove(SharedPrefKey.hips);
    await _prefs.remove(SharedPrefKey.shoulders);
    await _prefs.remove(SharedPrefKey.armLength);
    await _prefs.remove(SharedPrefKey.inseam);
    await _prefs.remove(SharedPrefKey.height);
  }

  Future<void> getMeasurements() async {
    final cachedMeasurements = _getMeasurementsFromCache();

    if (cachedMeasurements != null) {
      currentMeasurements = cachedMeasurements;

      emit(MeasurementsState.success(cachedMeasurements));

      return;
    }

    emit(const MeasurementsState.loading());
    final token = await _getUserToken();
    if (token == null || token.isEmpty) {
      emit(const MeasurementsState.fail('User not found. Please login again.'));
      return;
    }

    final result = await _repo.getMeasurements(token: token);
    result.when(
      success: (data) {
        currentMeasurements = data.measurements;
        _saveMeasurements(data.measurements!);
        emit(MeasurementsState.success(data.measurements!));
      },
      failure: (message) {
        currentMeasurements = null;
        emit(MeasurementsState.fail(message));
      },
    );
  }

  Future<void> updateMeasurements(MeasurementsModel request) async {
    emit(const MeasurementsState.loading());
    final token = await _getUserToken();
    if (token == null || token.isEmpty) {
      emit(const MeasurementsState.fail('User not found. Please login again.'));
      return;
    }

    final result = await _repo.updateMeasurements(token: token, body: request);
    result.when(
      success: (data) {
        currentMeasurements = data.measurements;
        _saveMeasurements(data.measurements!);
        emit(MeasurementsState.success(data));
      },
      failure: (message) {
        currentMeasurements = null;
        emit(MeasurementsState.fail(message));
      },
    );
  }

  Future<void> deleteMeasurements() async {
    emit(const MeasurementsState.loading());
    final token = await _getUserToken();
    if (token == null || token.isEmpty) {
      emit(const MeasurementsState.fail('User not found. Please login again.'));
      return;
    }

    final result = await _repo.deleteMeasurements(token: token);
    result.when(
      success: (data) {
        currentMeasurements = null;
        _clearMeasurementsCache();
        emit(MeasurementsState.success(data));
      },
      failure: (message) => emit(MeasurementsState.fail(message)),
    );
  }
}
