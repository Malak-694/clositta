import 'package:freezed_annotation/freezed_annotation.dart';

part  'rate_products_state.freezed.dart';

@freezed
class RateProductsState<T> with _$RateProductsState {
  const factory RateProductsState.initial() = _Initial;
  const factory RateProductsState.loading() = Loading;
  const factory RateProductsState.success(  T data) = Success<T>;
  const factory RateProductsState.fail(String message) = Fail;
}
