import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_state.freezed.dart';

@freezed
class OrderState<T> with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = Loading;
  const factory OrderState.success(T data) = Success<T>;
  const factory OrderState.fail(String message) = Fail;
}
