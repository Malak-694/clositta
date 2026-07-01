import 'package:freezed_annotation/freezed_annotation.dart';

part 'complete_outfit_state.freezed.dart';

@freezed
class CompleteOutfitState<T> with _$CompleteOutfitState<T> {
  const factory CompleteOutfitState.initial() = _Initial;
  const factory CompleteOutfitState.loading() = Loading;
  const factory CompleteOutfitState.success(T data) = Success<T>;
  const factory CompleteOutfitState.fail(String message) = Fail;
}