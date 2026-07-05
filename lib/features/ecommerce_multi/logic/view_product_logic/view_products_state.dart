import 'package:freezed_annotation/freezed_annotation.dart';

part  'view_products_state.freezed.dart';

@freezed
class ViewProductsState<T> with _$ViewProductsState<T> {
  const factory ViewProductsState.initial() = _Initial<T>;
  const factory ViewProductsState.loading() = Loading<T>;
  const factory ViewProductsState.success(T data) = Success<T>;
  const factory ViewProductsState.fail(String message) = Fail<T>;
}
