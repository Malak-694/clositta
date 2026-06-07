import 'package:freezed_annotation/freezed_annotation.dart';

part 'measurements_state.freezed.dart';

@freezed
abstract class MeasurementsState<T> with _$MeasurementsState<T> {
  const factory MeasurementsState.initial() = _Initial;
  const factory MeasurementsState.loading() = Loading;
  const factory MeasurementsState.success(T data) = Success<T>;
  const factory MeasurementsState.fail(String message) = Fail;
}
