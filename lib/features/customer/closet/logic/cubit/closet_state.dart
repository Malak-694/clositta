import 'package:freezed_annotation/freezed_annotation.dart';

part  'closet_state.freezed.dart';

@freezed
abstract class ClosetState<T> with _$ClosetState<T> {
  const factory ClosetState.initial() = _Initial;
  const factory ClosetState.loading() = Loading;
  const factory ClosetState.success(T data) = Success<T>;
  const factory ClosetState.fail(String message) = Fail;
} 
