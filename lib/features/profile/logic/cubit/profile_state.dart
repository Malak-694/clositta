import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState<T> with _$ProfileState<T> {
  const factory ProfileState.initial()              = _Initial;
  const factory ProfileState.loading()              = _Loading;
  const factory ProfileState.success(T data)        = _Success<T>;
  const factory ProfileState.fail(String message)   = _Fail;
}