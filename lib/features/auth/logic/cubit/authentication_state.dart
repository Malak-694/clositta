
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthState<T> with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.success(T data) = Success<T>;
  const factory AuthState.fail(String message) = Fail;
}