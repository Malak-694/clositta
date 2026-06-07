import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/customer/measurements/data/measurements_repo.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_model.dart';
import 'package:chicora/features/customer/measurements/logic/cubit/measurements_state.dart';

class MeasurementsCubit extends Cubit<MeasurementsState> {
  final MeasurementsRepo _repo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  MeasurementsModel? currentMeasurements;

  MeasurementsCubit({required MeasurementsRepo repo})
      : _repo = repo,
        super(const MeasurementsState.initial());

  Future<String?> _getUserId() async {
    return _prefs.getSecureData(SharedPrefKey.id);
  }

  Future<void> getMeasurements() async {
    emit(const MeasurementsState.loading());
    final userId = await _getUserId();
    if (userId == null || userId.isEmpty) {
      emit(const MeasurementsState.fail('User not found. Please login again.'));
      return;
    }

    final result = await _repo.getMeasurements(userId: userId);
    result.when(
      success: (data) {
        currentMeasurements = data.measurements;
        emit(MeasurementsState.success(data));
      },
      failure: (message) {
        currentMeasurements = null;
        emit(MeasurementsState.fail(message));
      },
    );
  }

  Future<void> saveMeasurements(MeasurementsRequest request) async {
    emit(const MeasurementsState.loading());
    final userId = await _getUserId();
    if (userId == null || userId.isEmpty) {
      emit(const MeasurementsState.fail('User not found. Please login again.'));
      return;
    }

    ApiResult<SaveMeasurementsResponse> result;
    if (currentMeasurements != null) {
      result = await _repo.updateMeasurements(userId: userId, body: request);
    } else {
      result = await _repo.createMeasurements(userId: userId, body: request);
      final conflict = result.maybeWhen(
        failure: (message) => message.contains('already exist'),
        orElse: () => false,
      );
      if (conflict) {
        result = await _repo.updateMeasurements(userId: userId, body: request);
      }
    }

    result.when(
      success: (data) {
        currentMeasurements = data.measurements;
        emit(MeasurementsState.success(data));
      },
      failure: (message) => emit(MeasurementsState.fail(message)),
    );
  }

  Future<void> deleteMeasurements() async {
    emit(const MeasurementsState.loading());
    final userId = await _getUserId();
    if (userId == null || userId.isEmpty) {
      emit(const MeasurementsState.fail('User not found. Please login again.'));
      return;
    }

    final result = await _repo.deleteMeasurements(userId: userId);
    result.when(
      success: (data) {
        currentMeasurements = null;
        emit(MeasurementsState.success(data));
      },
      failure: (message) => emit(MeasurementsState.fail(message)),
    );
  }
}
