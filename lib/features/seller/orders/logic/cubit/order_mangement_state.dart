import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_mangement_state.freezed.dart';

@freezed
class OrderMangementState<T> with _$OrderMangementState {
  const factory OrderMangementState.initial() = _Initial;
  const factory OrderMangementState.loading() = Loading;
  const factory OrderMangementState.success(T data) = Success<T>;
  const factory OrderMangementState.fail(String message) = Fail;
}
