import 'package:freezed_annotation/freezed_annotation.dart';

part  'view_products_state.freezed.dart';

@freezed
class ViewProductsState<T> with _$ViewProductsState {
  const factory ViewProductsState.initial() = _Initial;
  const factory ViewProductsState.loading() = Loading;
  const factory ViewProductsState.success(  T data) = Success<T>;
  const factory ViewProductsState.fail(String message) = Fail;
}
